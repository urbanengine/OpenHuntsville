Pakyow::App.routes(:people) do

  include SharedRoutes

  expand :restful, :people, '/people', :before => :route_head do

    collection do

      patch 'upload' do
        if request.xhr?
          filename = params['files'].first[:filename]
          uploaded_file = params['files'].first[:tempfile].path
          temp_image_file = "/tmp/#{SecureRandom.uuid}#{File.extname(uploaded_file)}"

          # Copy the uploaded file to /tmp.
          FileUtils.cp(uploaded_file, temp_image_file)
          pp uploaded_file
          pp temp_image_file

          # Resize the image.
          image = MiniMagick::Image.new(temp_image_file)
          image = resize_and_crop(image,160)

          # Generate the JSON response.
          response_data = {}
          response_data['files'] = []
          response_data['files'] << {name: filename, temp: File.basename(temp_image_file), size: 256}

          send response_data.to_json, 'application/json'
        else
          puts "fail"
        end
      end

      get 'slideshow' do
        people = People.where("approved = true").all
        ran = session[:random].to_i*100
        subset = Array.new
        people.each { |person|
          unless person.image_url.nil? || person.image_url.length == 0 || person.image_url == "/img/profile-backup.png"
            subset.push(person)
          end
        }
        shuffled = subset.shuffle(random: Random.new(ran))
        view.scope(:people).apply(shuffled)
        view.scope(:head).apply(request)
      end

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

      get 'search' do
        needle = params[:s]
        fffound = Array.new
        search_terms = ""
        unless needle.nil? || needle.length == 0
          needles = needle.split
          haystack = People.where("approved = true").all
          cats = Array.new
          all_cats = Category.all
          needles.each_with_index { |this_needle,index|
            this_needle.gsub!(/\W+/, '')
            unless index == 0
              search_terms << " "
            end
            search_terms << this_needle
            all_cats.each { |tmp_cat|
              if tmp_cat.category.downcase.include? this_needle.downcase
                unless cats.include? tmp_cat
                  cats.push(tmp_cat)
                end
              end
            }
          }
          needles.each { |this_needle|
            haystack.each { |person|
              unless fffound.include? person || person.first_name.nil? || person.first_name.length == 0
                if person.first_name.downcase.include? this_needle.downcase
                  fffound.push(person)
                end
              end
              unless fffound.include? person || person.last_name.nil? || person.last_name.length == 0
                if person.last_name.downcase.include? this_needle.downcase
                  fffound.push(person)
                end
              end
              unless fffound.include? person || person.bio.nil? || person.bio.length == 0
                if person.bio.downcase.include? this_needle.downcase
                  fffound.push(person)
                end
              end

              unless person.categories.nil?
                unless person.categories.length == 0
                  jsn = person.categories.to_s
                  array = JSON.parse(jsn)
                  array.each { |item|
                    cats.each { |cat|
                      if item == cat.id.to_s
                        unless fffound.include? person
                          fffound.push(person)
                        end
                      end
                    }
                  }
                end
              end

            }
          }
        end
        view.scope(:people).apply(fffound)
        all_cats = Category.order(:slug).all
        parent_cats = []
        all_cats.each { |item|
          if item.parent_id.nil?
            parent_cats.push(item)
          end
        }
        parent_cats.unshift("everyone")
        view.scope(:categories_menu).apply(parent_cats)
        tmp = Search.new()
        tmp.search_terms = search_terms
        tmp.number_results = fffound.length.to_s
        view.scope(:search_results).apply(tmp)

        view.scope(:head).apply(request)
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

      get 'spam/:id', :before => :is_admin_check do
        success = 'failure'
        spammer = People[params[:id]]
        spammer.spam = true
        spammer.save
        if request.xhr?
          success = 'success'
        else
          redirect request.referer
        end
        send success
      end

      get 'approve/:id', :before => :is_admin_check do
        success = 'failure'
        approve_me = People[params[:id]]
        approve_me.approved = true
        approve_me.save
        if request.xhr?
          success = 'success'
        else
          redirect request.referer
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
      view.scope(:head).apply(request)
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
        try_again = '/people/new'
        pp try_again
        presenter.path = try_again
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
  all_cats = Category.order(:slug).all
  parent_cats = []
  all_cats.each { |item|
    if item.parent_id.nil?
      parent_cats.push(item)
    end
  }
  parent_cats.unshift("everyone")
  view.scope(:categories_menu).apply(parent_cats)
  view.scope(:head).apply(request)
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
 view.scope(:head).apply(request)
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
  view.scope(:head).apply(request)
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
  pp people.first_name
  people.last_name = params[:people][:last_name]
  pp people.last_name
  people.company = params[:people][:company]
  pp people.company
  unless params[:people][:twitter].nil? || params[:people][:twitter].length == 0
    twit_url = params[:people][:twitter].downcase
    unless twit_url.include? "http"
      twit_url = "http://www.twitter.com/" + twit_url
    end
    people.twitter = twit_url
  end
  pp people.twitter

  unless params[:people][:linkedin].nil? || params[:people][:linkedin].length == 0
    link_url = params[:people][:linkedin].downcase
    unless link_url.include? "http"
      link_url = "http://www.linkedin.com/in/" + link_url
    end
    people.linkedin = link_url
  end
  pp people.linkedin

  unless params[:people][:url].nil? || params[:people][:url].length == 0
    my_url = params[:people][:url].downcase
    unless my_url.include? "http"
      my_url = "http://" + my_url
    end
    people.url = my_url
  end
  pp people.url

  people.other_info = params[:people][:other_info]
  pp people.other_info
  unless params[:people][:image_url].nil? || params[:people][:image_url].length == 0
    people.image_url = params[:people][:image_url]
  end
  pp people.image_url
  if people.image_url.nil? || people.image_url.length == 0 || params[:people][:image_url].length == 0
    people.image_url = find_image_url(params[:people][:email])
  end
  pp people.image_url
  category_array = [params[:people][:category_one],params[:people][:category_two],params[:people][:category_three]]
  people.categories = Sequel::Postgres::JSONHash.new(category_array)
  pp people.categories
  if unique_url(people.id,params[:people][:custom_url])
    unless slug_contains_invalid(params[:people][:custom_url].downcase)
      people.custom_url = params[:people][:custom_url].downcase
    end
    # people.custom_url = params[:people][:custom_url].downcase.gsub(/[^0-9a-z]/i, '-')
  end
  pp people.custom_url
  unless current_user.nil? || current_user.admin.nil? || current_user.admin == false
    people.admin = params[:people][:admin]
    people.approved = params[:people][:approved]
  end
  pp people.admin
  pp people.approved
  if params[:people][:bio].length < 161
    people.bio = params[:people][:bio]
  end
  pp people.bio
  unless params[:people][:email].nil? || params[:people][:email].length == 0
    people.email = params[:people][:email].downcase
  end
  pp people.email
  pass = params[:people][:password]
  pass_conf = params[:people][:password_confirmation]
  unless pass.nil? || pass_conf.nil? || pass.length == 0 || pass_conf.length == 0
    if pass == pass_conf
      people.password = pass
      people.password_confirmation = pass_conf
      pp people.password
    end
  end


  if params.has_key?('tempimage')
    unless params['tempimage'].nil? || params['tempimage'].length == 0
      image_basename = params['tempimage']
      image_filename = "/tmp/#{params['tempimage']}"

      if File.exists? image_filename
        # Get the image size.
        image = MiniMagick::Image.open(image_filename)

        # Upload to S3.
        s3 = Aws::S3::Resource.new(region: 'us-east-1')
        s3.bucket('openhsv.com/website-uploads').object(image_basename).upload_file(image_filename, acl:'public-read')
        # Remove the image from /tmp after uploading it.
        FileUtils.rm(image_filename)
        people.image_url = 'https://s3.amazonaws.com/openhsv.com/website-uploads/' + image_basename
      else
        pp "File does not exist"
      end
    else
      puts "TEMPIMAGE NIL"
      pp params
    end
  end
pp people.image_url
puts "ABOUT TO SAVE"
    people.save
    puts "SAVED"
  if people.valid?
    # Save
  elsif names_nil
    pp "PEOPLE ERRORS"
    pp people.errors
    # redirect '/people/create-profile'
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
    c2 = Category[category_array[1]]
    unless c2.nil? || c2.category.nil?
      cat2 = c2.category
    end
  end
  cat3 = ""
  unless category_array[2].nil? || category_array[2].length == 0
    c3 = Category[category_array[2]]
    unless c3.nil? || c3.category.nil?
      cat3 = c3.category
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
    # http://www.rubydoc.info/gems/slack-api
    redirect '/people/profile-created'
  elsif suspend_mail
    send_email_template(people,:account_suspension)
  elsif approve_mail
    send_email_template(people,:account_approval)
  end
  redirect '/people/' + people.custom_url + "/edit"
end

end
end
