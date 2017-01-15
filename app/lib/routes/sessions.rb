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
      if create_session(params[:session])
        redirect "/people/" + People[session[:people]].custom_url + "/edit"
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
