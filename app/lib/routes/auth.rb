require 'securerandom'

Pakyow::App.routes(:auth) do
    include SharedRoutes

    expand :restful, :auth, '/auth', :before => :route_head do
        collection do
            
            get '/' do
                redirect '/errors/403'
            end

            get 'verifyemail/:token' do
                auth = Auth.where(Sequel.lit('token = ?', params[:token])).first

                #if auth.expiration_date < Time.now.utc
                #    auth.delete
                #end

                if auth.nil?
                    redirect "/errors/404"
                end

                view.scope(:head).apply(request)
                view.scope(:main_menu).apply(request)
                view.scope(:auth).with do |view|
                    view.bind(auth)
                    handle_errors(view)
                  end
            end

            post 'verifyemail/:token' do
                auth = Auth.where(Sequel.lit('token = ? AND expiration_date < ?', params[:token], Time.now.utc)).first
                if auth.nil?
                    redirect "/errors/404"
                end

                user = People.where(Sequel.lit('id = ?', auth.people_id)).first
                if user.nil?
                    redirect "/errors/404"
                end

                if user.approved
                    @errors = ['Your account is already approved. Please Log In to continue.']
                    reroute 'auth/verifyemail/' + params[:token], :get
                end

                password = params[:auth][:password]
                passwordConfirmation = params[:auth][:confirmPassword]

                puts password
                puts passwordConfirmation

                if password != passwordConfirmation
                    @errors = ['Passwords do not match. Please enter the same password twice.']
                    reroute 'auth/verifyemail/' + params[:token], :get
                end

                user.password = password
                user.password_confirmation = passwordConfirmation
                user.approved = true
                user.save

                view.scope(:head).apply(request)
                view.scope(:main_menu).apply(request)

                @errors = ['Account successfully approved.']
                reroute 'auth/verifyemail/' + params[:token], :get
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