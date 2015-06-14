Pakyow::App.routes(:sessions) do
  
  restful :session, '/sessions' do
    new do
      view.scope(:session).with do |view|
        view.bind(@session || Session.new({}))
        handle_errors(view)
      end
    end

    create do
      @session = Session.new(params[:session])
      if user = User.auth(@session)
        session[:user] = user.id
        cookies[:user] = user.id
        puts "authenticated in sessions.rb create with @session " + @session.to_s
        redirect router.path(:default)
      else
        @errors = ['Invalid email and/or password']
        reroute router.group(:session).path(:new), :get
      end
    end

    remove do
      session[:user] = nil
      redirect "/"
    end
  end
end 
