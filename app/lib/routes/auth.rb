require 'securerandom'

Pakyow::App.routes do
    include SharedRoutes

    expand :restful, :auth, '/auth', :before => :route_head do
        collection do
            
            get '/' do
                redirect '/errors/403'
            end

            get 'verifyemail/' do
                # TODO: David here is your playground for your verify email work
            end

            get 'forgotpassword/' do
                view.scope(:head).apply(request)
                view.scope(:main_menu).apply(request)
                view.scope(:auth).with do |view|
                    view.bind(@auth || Auth.new({}))
                    handle_errors(view)
                  end
            end

            post 'forgotpassword/' do
                email = params[:auth][:email]
                user = People.where(Sequel.lit('email = ? AND approved = true', email)).first
                
                if user.nil? == false
                    data = {
                        "people_id" => user.id,
                        "token" => SecureRandom.uuid,
                        "expiration_date" => Time.now.utc
                    }

                    auth = Auth.new(data)
                    auth.save

                    @errors = ['Please check your email for a link to reset your password.']
                    server = "http://localhost:3001/"
                    #unless ENV['RACK_ENV']== "development"
                    #    server = "https://www.openhuntsville.com/"
                    #end
                    options = {
                        "passwordResetLink" => server + "people/passwordreset/" + auth.token
                    }
                    
                    send_email_template(user, :auth, options)
                    reroute 'auth/forgotpassword/', :get
                else
                    @errors = ['No account exists with that e-mail address.']
                    reroute 'auth/forgotpassword/', :get
                end

                view.scope(:head).apply(request)
                view.scope(:main_menu).apply(request)
                view.scope(:auth).apply(request)
                view.scope(:errors).apply(request)
            end
        end
    end
end