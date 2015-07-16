Pakyow::App.routes(:people) do
  
  include SharedRoutes

  expand :restful, :people, '/people', :before => :route_head do

    collection do
      get 'create-profile', :before => :edit_profile_check do
        view.scope(:people).bind(People[params[:people_id]])
        people = People[session[:people]]
      end
      
      get 'account-registered' do
        view.scope(:head).apply(request)
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
      pp params
      people = People.new(params[:people])
      people.custom_url = params[:people][:email].gsub(/[^0-9a-z ]/i, '-')
      puts people.custom_url.downcase
      people.approved = false
      people.save
      redirect '/people/account-registered'
    end

# GET /people; same as Index
action :list do
  log_debug(People.all)
  view.scope(:people).apply(People.all)
  view.scope(:head).apply(request)
end

# GET /people/:id
action :show do
  people = get_people_from_people_id(params[:people_id])
  
  if people.nil? || people.length == 0 || people[0].nil? || people[0].to_s.length == 0
   redirect '/errors/404'
  end
  unless people[0].approved || People[session[:people]].admin
    redirect '/errors/404'
  end
 view.scope(:people).apply(people)
end

# # GET /people/:id/edit
# action :edit, :before => :edit_profile_check do
#   person = People[params[:people_id]]
#   view.scope(:people).bind(person)
#   # view.scope(:facility).apply(Facility[Resource[params[:resource_id]].facility_id])
#   unless person.nil? || person.categories.nil?
#     jsn = person.categories.to_s
    
#     array = JSON.parse(jsn)    
#     pp "IN JSON"
#     view.scope(:lorem).bind(json) 
#   else
#  view.scope(:lorem).bind(Object.new)
#     pp "OOPS"
#     pp person
#   end

# end

action :edit, :before => :edit_profile_check do
  
  people = get_people_from_people_id(params[:people_id])
  pp people
  view.scope(:people).bind(people)
  unless people.nil? || people.length == 0 || people[0].nil? || people[0].to_s.length == 0 || people[0].categories.nil?
   
   jsn = people.categories.to_s
    
    array = JSON.parse(jsn)    
    pp "IN JSON"
    view.scope(:lorem).bind(json) 
   else
    # redirect '/errors/404'
    view.scope(:lorem).bind(Object.new)
    pp "OOPS"
    pp people
  end
 # view.scope(:people).apply(people)
 #  view.scope(:head).apply(request)
end

action :update, :before => :edit_profile_check do

  people = People[params[:people_id]]
  people.first_name = params[:people][:first_name]
  people.last_name = params[:people][:last_name]
  people.company = params[:people][:company]
  people.twitter = params[:people][:twitter]
  people.linkedin = params[:people][:linkedin]
  people.url = params[:people][:url]
  people.other_info = params[:people][:other_info]
  people.image_url = params[:people][:image_url]
  people.categories_string = params[:people][:categories_string]

  category_array = [params[:lorem][:category_one],params[:lorem][:category_two],params[:lorem][:category_three]]
  people.categories = Sequel::Postgres::JSONHash.new(category_array)
  if unique_url(people.id,params[:people][:custom_url])
    people.custom_url = params[:people][:custom_url]
  end
  current_user = People[cookies[:people]]
  unless current_user.nil? || current_user.admin.nil? || current_user.admin == false
    people.admin = params[:people][:admin]
  end
  if params[:people][:bio].length < 161
    people.bio = params[:people][:bio]
  end
  # JSON
  categories = {}
  categories[0] = ''
  categories[1] = ''
  categories[2] = ''
  log_debug(params[:people])
  # people[:categories] = Sequel::Postgres::JSONHash.new(data)
  
  # Save 
  people.save

  presenter.path = 'people/edit'
  view.scope(:people).apply(People[params[:people_id]])
  redirect '/people/' + people.id.to_s
end

# TODO
  # action :remove do
  #   people = People[params[:people_id]]
  #   people.delete

  #   if current_people == People[params[:people_id]]
  #     session[:people] = nil
  #     redirect :default
  #   else
  #     redirect "/people"
  #   end
  # end
end
end
