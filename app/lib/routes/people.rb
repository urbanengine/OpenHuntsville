Pakyow::App.routes(:people) do
  
  include SharedRoutes

  expand :restful, :people, '/people', :before => :route_head do

    collection do

      get 'unapproved' do
        if cookies[:people].nil? 
          redirect '/errors/401'
        else
          person = People[cookies[:people]]
          unless person.admin
            redirect '/errors/403'
          end
        end
        subset = Array.new
        all =  People.all
        all.each { |person|
          if person.approved.nil? || !(person.approved)
            subset.push(person)
          end
        }
        view.scope(:people).apply(subset)
        view.scope(:head).apply(request)
        view.scope(:main_menu).apply(request)
      end

      get 'profile-created' do
        if cookies[:people].nil? 
          redirect '/people/new'
        else
          view.scope(:people).bind(People[cookies[:people]])
          view.scope(:head).apply(request)
          view.scope(:main_menu).apply(request)
        end
      end

      get 'create-profile' do
        if cookies[:people].nil? 
          redirect '/people/new'
        else
          view.scope(:people).bind(People[cookies[:people]])
          view.scope(:head).apply(request)
          view.scope(:main_menu).apply(request)
        end
      end
      
      get 'account-registered' do
        if cookies[:people].nil? 
          redirect '/people/new'
        else
          view.scope(:head).apply(request)
          view.scope(:main_menu).apply(request)
          view.scope(:people).bind(People[cookies[:people]])
        end
      end

      get 'url-available' do
        success = 'failure'
        if request.xhr?
          id = params[:people][:id]
          url = params[:people][:custom_url].downcase
          if unique_url(id,url)
            success = 'success'
          end
        else
          # Show 401 error if not Ajax request.
          handle 401
        end
        send success
      end
    end
    action :new do
      view.scope(:people).with do
        bind(People.new)
      end
      view.scope(:people).prop(:type).remove
      view.scope(:people).prop(:type_label).remove

    end

    action :create do
      c_params = { "email" => params[:people][:email].downcase, "password" => params[:people][:password], "password_confirmation" => params[:people][:password_confirmation]}
      people = People.new(c_params)
      custom_url = params[:people][:email].gsub(/[^0-9a-z]/i, '-')
      stop_the_loop = false
      i = 2
      until stop_the_loop do
        person = People.where("custom_url = ?",custom_url).first
        if person.nil?
          stop_the_loop = true
        else
          custom_url = custom_url + i.to_s
        end
      end
      people.custom_url = custom_url
      people.image_url = find_image_url(params[:people][:email])
      people.approved = false
      # TODO: If valid, save; if invalid, redirect
      if people.valid?
        people.save
        # TODO 
        if create_session(c_params)
          redirect '/people/create-profile'
        else
          redirect '/'
        end
      else
        presenter.path = '/people/new'
        view.scope(:people).with do |ctx|
          ctx.bind(people)

          ctx.scope(:error).repeat(people.errors.full_messages) do |view, msg|
            view.text = msg
          end
        end
      end
    end

# GET /people; same as Index
action :list do
  if session[:random].nil?
    session[:random] = (rand(0...100)).to_s
  end
  people = People.where("approved = true").all
  ran = session[:random].to_i*100
  shuffled = people.shuffle(random: Random.new(ran))
  view.scope(:people).apply(shuffled)
  all_cats = Category.all
  parent_cats = []
  all_cats.each { |item|
    if item.parent_id.nil?
      parent_cats.push(item)
    end
  }
  parent_cats.unshift("everyone")
  view.scope(:categories_menu).apply(parent_cats)
end

# GET /people/:id
action :show do
  people = get_people_from_people_id(params[:people_id])
  if people.nil? || people.length == 0 || people[0].nil? || people[0].to_s.length == 0
   redirect '/errors/404'
  end
  unless people[0].approved || People[session[:people]].admin || people[0].id == session[:people].to_i
    redirect '/errors/404'
  end
 view.scope(:people).apply(people)
end

action :edit, :before => :edit_profile_check do
  
  people = get_people_from_people_id(params[:people_id])
  unless people[0].nil?
    view.scope(:people)[0].bind(people[0])
    view.scope(:people)[1].bind(people[0])
  end
end

action :update, :before => :edit_profile_check do
  people = People[params[:people_id]]

  # 1. When an unapproved user edits
  # 2. When admin turns off or on 
  first_edit_mail = false
  approve_mail = false
  suspend_mail = false
  current_user = nil
  names_nil = false
  unless session[:people].nil?
    current_user = People[session[:people]]
  end

  if current_user.first_name.nil? || current_user.first_name.length == 0
    if params[:people][:first_name].nil? || params[:people][:first_name].length == 0
      names_nil = true
    else
      first_edit_mail = true
    end
  end

  unless current_user.nil?
    if current_user.admin.nil? || !(current_user.admin)
      if people.approved.nil? || !(people.approved)
        # Current user is NOT admin
        # Person is not approved
        first_edit_email = true
      end
    else
      # Current user is ADMIN
      pp '# Current user is ADMIN'
      pp params[:people]
      pp people
      if params[:people][:approved] && !(people.approved)
        # Admin is approving user
        approve_mail = true
      elsif people.approved
        unless params[:people].has_key?("approved")
          # Admin is suspending user
          suspend_mail = true
        end
      end
    end
  end

  people.first_name = params[:people][:first_name]
  people.last_name = params[:people][:last_name]
  people.company = params[:people][:company]
  unless params[:people][:twitter].nil? || params[:people][:twitter].length == 0
    twit_url = params[:people][:twitter].downcase
    unless twit_url.include? "http"
      twit_url = "http://www.twitter.com/" + twit_url
    end
    people.twitter = twit_url
  end
  unless params[:people][:linkedin].nil? || params[:people][:linkedin].length == 0
    link_url = params[:people][:linkedin].downcase
    unless link_url.include? "http"
      link_url = "http://www.linkedin.com/in/" + link_url
    end
    people.linkedin = link_url
  end
  people.url = params[:people][:url]
  people.other_info = params[:people][:other_info]
  unless params[:people][:image_url].nil? || params[:people][:image_url].length == 0 
    people.image_url = params[:people][:image_url]
  end
  if people.image_url.nil? || people.image_url.length == 0 || params[:people][:image_url].length == 0
    people.image_url = find_image_url(params[:people][:email])
  end
  category_array = [params[:people][:category_one],params[:people][:category_two],params[:people][:category_three]]
  people.categories = Sequel::Postgres::JSONHash.new(category_array)
  if unique_url(people.id,params[:people][:custom_url])
    people.custom_url = params[:people][:custom_url].downcase
    # people.custom_url = params[:people][:custom_url].downcase.gsub(/[^0-9a-z]/i, '-')
  end
  current_user = People[cookies[:people]]
  unless current_user.nil? || current_user.admin.nil? || current_user.admin == false
    people.admin = params[:people][:admin]
  end
  unless current_user.nil? || current_user.admin.nil? || current_user.admin == false
    people.approved = params[:people][:approved]
  end
  if params[:people][:bio].length < 161
    people.bio = params[:people][:bio]
  end
  unless params[:people][:email].nil? || params[:people][:email].length == 0
    people.email = params[:people][:email].downcase
  end
  pass = params[:people][:password]
  pass_conf = params[:people][:password_confirmation]
  unless pass.nil? || pass_conf.nil? || pass.length == 0 || pass_conf.length == 0
    if pass == pass_conf
      people.password = pass
      people.password_confirmation = pass_conf
    end
  end

  if people.valid?
    # Save 
    people.save
  elsif names_nil
    redirect '/people/create-profile'
  end

  cat1 = ""
  unless category_array[0].nil? || category_array[0].length == 0
    c1 = Category[category_array[0]]
    unless c1.nil? || c1.category.nil?
      cat1 = c1.category
    end
  end
  cat2 = ""
  unless category_array[1].nil? || category_array[1].length == 0
    c1 = Category[category_array[1]]
    unless c1.nil? || c1.category.nil?
      cat1 = c1.category
    end
  end
  cat3 = ""
  unless category_array[2].nil? || category_array[2].length == 0
    c1 = Category[category_array[2]]
    unless c1.nil? || c1.category.nil?
      cat1 = c1.category
    end
  end

  if first_edit_email
    body = "<ul><li>:email => " + printme(people.email) + ",</li>
    <li>:first_name => " + printme(people.first_name) + ",</li>
    <li>:last_name => " + printme(people.last_name) + ",</li>
    <li>:company => " + printme(people.company) + ",</li>
    <li>:twitter => " + printme(people.twitter) + ",</li>
    <li>:linkedin => " + printme(people.linkedin) + ",</li>
    <li>:url => " + printme(people.url) + ",</li>
    <li>:categories => " + printme(cat1) + ", " + printme(cat2) + ", " + printme(cat3) + ",</li>
    <li>:created_at => " + printme(people.created_at) + ",</li>
    <li>:updated_at => " + printme(people.updated_at) + ",</li>
    <li>:image_url => " + printme(people.image_url) + ",</li>
    <li>:custom_url => " + printme(people.custom_url) + ",</li>
    <li>:admin => " + printme(people.admin) + ",</li>
    <li>:bio => " + printme(people.bio) + ",</li>
    <li>:approved => " + printme(people.approved) + "</li></ul>"    
    
    person = ""
    unless people.first_name.nil?
      person = people.first_name + " "
      unless people.last_name.nil?
        person = person + people.last_name + " - "
      end
    end
    person = person + people.email

    email_us("Profile created by " + person,body)
    send_email_template(people,:account_creation)
    redirect '/people/profile-created'
  elsif suspend_mail
    send_email_template(people,:account_suspension)
  elsif approve_mail
    send_email_template(people,:account_approval)
  end
  redirect '/people/'
end

end
end
