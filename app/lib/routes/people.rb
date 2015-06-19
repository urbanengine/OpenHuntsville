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
action :edit do
  log_debug("/app/lib/routes/people.rb :: edit :: session :: ", session.to_s)
  log_debug("/app/lib/routes/people.rb :: edit :: cookies[:people] :: ", cookies[:people])
  people = People[cookies[:people]]
  if people.nil?
    log_debug("/app/lib/routes/people.rb :: edit :: people is nil")

    redirect "/errors/403"
  elsif people.id.to_s != params[:people_id].to_s
    log_debug("/app/lib/routes/people.rb :: edit :: people.id != params[:people_id]")
    log_debug(people.id)
    log_debug(params)
    redirect "/errors/403"
  end

  view.scope(:people).bind(People[params[:people_id]])
  people = People[session[:people]]
  log_debug("/app/lib/routes/people.rb :: edit :: People :: ", people.id.to_s)
end

action :update do
  log_debug("/app/lib/routes/people.rb :: update :: session :: ", session.to_s)
  log_debug("/app/lib/routes/people.rb :: update :: cookies[:people] :: ", cookies[:people])
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
  redirect '/'
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
