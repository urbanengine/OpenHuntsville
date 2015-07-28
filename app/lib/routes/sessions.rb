Pakyow::App.routes(:sessions) do
  
  restful :session, '/sessions' do
    new do
      view.scope(:head).apply(request)
      view.scope(:main_menu).apply(request)
      view.scope(:session).with do |view|
        view.bind(@session || Session.new({}))
        handle_errors(view)
      end
    end

    create do
      @session = Session.new(params[:session])
      if people = People.auth(@session)
        session[:people] = people.id
        cookies[:people] = people.id
        unless people.id.nil?
          redirect "/people/" + people.id.to_s + "/edit"
        else
          redirect "/errors/401"
        end
      else
        @errors = ['Invalid email and/or password']
        reroute router.group(:session).path(:new), :get
      end
    end

    remove do
      session[:people] = nil
      redirect "/"
    end
  end
end 
