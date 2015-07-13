Pakyow::App.routes(:people) do
  include SharedRoutes

  expand :restful, :people, '/people', :before => :route_head do

    action :new do
      view.scope(:people).with do
        bind(People.new)
      end
      view.scope(:people).prop(:type).remove
      view.scope(:people).prop(:type_label).remove

    end

    action :create do
      people = People.new(params[:people])
      people.save
      redirect '/people/'+people.id.to_s+'/edit'
    end

# GET /people; same as Index
action :list do
  log_debug("/app/lib/routes/people.rb :: list :: session :: ", session.to_s)
  log_debug("/app/lib/routes/people.rb :: list :: cookies[:people] :: ", cookies[:people])
  log_debug("/app/lib/routes/people.rb :: list :: cookies :: ", cookies.to_s)
  log_debug("/app/lib/routes/people.rb :: list :: params :: ", params.to_s)
  log_debug(People.all)
  view.scope(:people).apply(People.all)
  # view.scope(:head).apply(Object.new)
end

# GET /people/:id
action :show do
  log_debug("/app/lib/routes/people.rb :: show :: session :: ", session.to_s)
  log_debug("/app/lib/routes/people.rb :: show :: cookies[:people]", cookies[:people])
  log_debug("/app/lib/routes/people.rb :: show :: cookies :: ", cookies.to_s)
  log_debug("/app/lib/routes/people.rb :: show :: params :: ", params.to_s)
  people = get_people_from_people_id(params[:people_id])
  log_debug("/app/lib/routes/people.rb :: show :: people :: ", people.to_s)
  
  
  if people.nil? || people.length == 0 || people[0].nil? || people[0].to_s.length == 0
   redirect '/errors/404'
  end
 view.scope(:people).apply(people)
end

# GET /people/:id/edit
action :edit, :before => :edit_profile_check do
  log_debug("/app/lib/routes/people.rb :: edit :: session :: ", session.to_s)
  log_debug("/app/lib/routes/people.rb :: edit :: cookies[:people] :: ", cookies[:people])

  person = People[params[:people_id]]
  view.scope(:people).bind(person)
  # view.scope(:facility).apply(Facility[Resource[params[:resource_id]].facility_id])
  unless person.nil? || person.categories.nil?
    jsn = person.categories.to_s
    
    array = JSON.parse(jsn)    
    pp "IN JSON"
    view.scope(:lorem).bind(json) 
  else
 view.scope(:lorem).bind(Object.new)
    pp "OOPS"
    pp person
  end

end

action :update, :before => :edit_profile_check do
  log_debug("/app/lib/routes/people.rb :: update :: session :: ", session.to_s)
  log_debug("/app/lib/routes/people.rb :: update :: cookies[:people] :: ", cookies[:people])
  pp params[:people]
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
  people.custom_url = params[:people][:custom_url]
  people.admin = params[:people][:admin]
  category_array = [params[:lorem][:category_one],params[:lorem][:category_two],params[:lorem][:category_three]]
  people.categories = Sequel::Postgres::JSONHash.new(category_array)
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
