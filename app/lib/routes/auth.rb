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

                if auth.nil?
                    redirect "/errors/404"
                end

                if auth.used == true
                    @errors = ['You have already verified your account. Please login to proceed.']
                    reroute '/login', :get
                end

                if auth.expiration_date < Time.now.utc
                    auth.used = true
                    auth.save
                    @errors = ['The time to verify your email has expired. Please contact davidhjones89@gmail.com']
                    reroute 'auth/verifyemail/' + params[:token], :get
                end

                view.scope(:head).apply(request)
                view.scope(:main_menu).apply(request)
                view.scope(:auth).with do |view|
                    view.bind(auth)
                    handle_errors(view)
                  end
            end

            post 'verifyemail/:token' do
                auth = Auth.where(Sequel.lit('token = ?', params[:token])).first
                if auth.nil?
                    redirect "/errors/404"
                end

                if auth.used == true
                    @errors = ['You have already verified your account. Please login to proceed.']
                    reroute '/login', :get
                end

                if auth.expiration_date < Time.now.utc
                    auth.used = true
                    auth.save
                    @errors = ['The time to verify your email has expired. Please contact davidhjones89@gmail.com']
                    reroute 'auth/verifyemail/' + params[:token], :get
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

                if password != passwordConfirmation
                    @errors = ['Passwords do not match. Please enter the same password twice.']
                    reroute 'auth/verifyemail/' + params[:token], :get
                end

                user.password = password
                user.password_confirmation = passwordConfirmation
                user.approved = true
                user.save

                auth.used = true
                auth.save

                session = {
                    "email" => user.email,
                    "password" => password
                }

                view.scope(:head).apply(request)
                view.scope(:main_menu).apply(request)

                @errors = ['Thank you for verifying your account. Please login to proceed.']
                redirect '/auth/auth0'
            end

            get 'forgotpassword/' do
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
                        "expiration_date" => (Time.now.utc + 1.day),
                        "used" => false
                    }

                    auth = Auth.new(data)
                    auth.save

                    @errors = ['Please check your email for a link to reset your password.']
                    send_auth_email(user, auth, :passwordreset)
                    reroute 'auth/forgotpassword/', :get
                else
                    @errors = ['No account exists with that e-mail address.']
                    reroute 'auth/forgotpassword/', :get
                end

                view.scope(:auth).apply(request)
                view.scope(:errors).apply(request)
            end

            get 'forgotpassword/:token' do
                auth = Auth.where(Sequel.lit('token = ?', params[:token])).first
                if auth.nil?
                    redirect "/errors/404"
                end

                if auth.expiration_date < Time.now.utc
                    auth.used = true
                    auth.save
                    @errors = ['The time to reset your password has expired. Please try again.']
                    reroute 'auth/forgotpassword', :get
                end

                presenter.path = 'auth/forgotpassword/edit'
                view.scope(:head).apply(request)
                view.scope(:main_menu).apply(request)
                view.scope(:auth).with do |view|
                    view.apply(auth)
                    handle_errors(view)
                  end
            end

            post 'forgotpassword/:token' do
                auth = Auth.where(Sequel.lit('token = ? AND expiration_date > ?', params[:token], Time.now.utc)).first
                if auth.nil?
                    redirect "/errors/404"
                end

                if auth.expiration_date < Time.now.utc
                    auth.used = true
                    auth.save
                    @errors = ['The time to reset your password has expired. Please try again.']
                    reroute 'auth/forgotpassword', :get
                end

                user = People.where(Sequel.lit('id = ?', auth.people_id)).first
                if user.nil?
                    redirect "/errors/404"
                end

                password = params[:auth][:password]
                passwordConfirmation = params[:auth][:confirmPassword]

                if password != passwordConfirmation
                    @errors = ['Passwords do not match. Please enter the same password twice.']
                    reroute 'auth/forgotpassword/' + params[:token], :get
                end

                user.password = password
                user.password_confirmation = passwordConfirmation
                user.save

                auth.used = true
                auth.save

                view.scope(:head).apply(request)
                view.scope(:main_menu).apply(request)

                @errors = ['You have successfully reset your passowrd. Please login to proceed.']
                reroute '/login', :get
            end

            expand :restful, :auth0, '/auth0' do
                collection do
                    get 'callback' do
                        put_token_in_cookies(request.env['omniauth.auth'])

                        user = get_user_from_cookies()
                        if user.nil?
                            redirect "/errors/404"
                        end
                        redirect '/'
                    end
                end
            end
        end
    end
end