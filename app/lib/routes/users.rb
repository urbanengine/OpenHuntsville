Pakyow::App.routes(:users) do
  include SharedRoutes

  expand :restful, :user, '/users', :before => :route_head do

    action :new do
      view.scope(:user).with do
        bind(User.new)
      end
      view.scope(:user).prop(:type).remove
      view.scope(:user).prop(:type_label).remove

    end

    action :create do
      user = User.new(params[:user])
      user.save
      redirect '/users/'+user.id.to_s+'/edit'
    end

# GET /users; same as Index
action :list do
  log_debug("/app/lib/routes/users.rb :: list :: session :: " + session.to_s)
  log_debug("/app/lib/routes/users.rb :: list :: cookies[:user] :: " + cookies[:user])
  log_debug("/app/lib/routes/users.rb :: list :: cookies :: " + cookies.to_s)
  log_debug("/app/lib/routes/users.rb :: list :: params :: " + params.to_s)
  log_debug(User.all)
  view.scope(:user).apply(User.all)
  # view.scope(:head).apply(Object.new)
end

# GET /users/:id
action :show do
  log_debug("/app/lib/routes/users.rb :: show :: session :: " + session.to_s)
  log_debug("/app/lib/routes/users.rb :: show :: cookies[:user]" + cookies[:user])
  log_debug("/app/lib/routes/users.rb :: show :: cookies :: " + cookies.to_s)
  log_debug("/app/lib/routes/users.rb :: show :: params :: " + params.to_s)
  id = params[:user_id]
  users = Array.new
  if id.include? "-"
    splitname = id.split("-")
    users = User.where("lower(first_name) = ? AND lower(last_name) = ?", splitname[0],splitname[1]).all
  else
    users[0] = User[params[:user_id]]
  end

  log_debug("/app/lib/routes/users.rb :: show :: users :: " + users.to_s)
  
  if users.nil? || users.length == 0 || users[0].nil? || users[0].length == 0
   redirect '/errors/404'
  end
 view.scope(:user).apply(users)
end

# GET /users/:id/edit
action :edit do
  log_debug("/app/lib/routes/users.rb :: edit :: session :: " + session.to_s)
  log_debug("/app/lib/routes/users.rb :: edit :: cookies[:user] :: " + cookies[:user])
  user = User[cookies[:user]]
  if user.nil?
    log_debug("/app/lib/routes/users.rb :: edit :: user is nil")

    redirect "/access-denied"
  elsif user.id.to_s != params[:user_id].to_s
    log_debug("/app/lib/routes/users.rb :: edit :: user.id != params[:user_id]")
    log_debug(user.id)
    log_debug(params)
    redirect "/access-denied"
  end

  view.scope(:user).bind(User[params[:user_id]])
  user = User[session[:user]]
  log_debug("/app/lib/routes/users.rb :: edit :: User :: " + user.id.to_s)
end

action :update do
  log_debug("/app/lib/routes/users.rb :: update :: session :: " + session.to_s)
  log_debug("/app/lib/routes/users.rb :: update :: cookies[:user] :: " + cookies[:user])
  user = User[params[:user_id]]
  user.first_name = params[:user][:first_name]
  user.last_name = params[:user][:last_name]
  user.company = params[:user][:company]
  user.twitter = params[:user][:twitter]
  user.linkedin = params[:user][:linkedin]
  user.url = params[:user][:url]
  user.other_info = params[:user][:other_info]
  user.image_url = params[:user][:image_url]
  user.categories_string = params[:user][:categories_string]
  # JSON
  categories = {}
  categories[0] = ''
  categories[1] = ''
  categories[2] = ''
  log_debug(params[:user])
  # user[:categories] = Sequel::Postgres::JSONHash.new(data)
  
  # Save 
  user.save

  presenter.path = 'users/edit'
  view.scope(:user).apply(User[params[:user_id]])
  redirect '/'
end

# TODO
  # action :remove do
  #   user = User[params[:user_id]]
  #   user.delete

  #   if current_user == User[params[:user_id]]
  #     session[:user] = nil
  #     redirect :default
  #   else
  #     redirect "/users"
  #   end
  # end
end
end
