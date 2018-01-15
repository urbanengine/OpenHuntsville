require 'securerandom'

Pakyow::App.routes do
    include SharedRoutes

    expand :restful, :auth_tokens, '/auth', :before => :route_head do
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
                view.scope(:auth_tokens).apply(request)
            end

            post 'forgotpassword/reset/' do
                email = params[:email]
                user = People.where(Sequel.lit('email = ? AND approved = true', email)).first

                if user.nil? == false
                    data = {
                        "people_id" => user.id,
                        "token" => SecureRandom.uuid,
                        "expiration_date" => Time.now.utc
                    }

                    token = AuthToken.new(data)
                    token.save

                    @errors = ['Please check your email for a link to reset your password.']
                    pp 'Email ready to be sent'
                    reroute 'auth/forgotpassword/', :get
                    # reroute router.group(:auth).path('forgotpassword'), :get
                else
                    @errors = ['No account exists with that e-mail address.']
                    pp 'no account exists with given e-mail address'
                    reroute 'auth/forgotpassword/'
                    #reroute router.group(:auth).path(:forgotpassword), :get
                end

                view.scope(:head).apply(request)
                view.scope(:main_menu).apply(request)
                view.scope(:auth_tokens).apply(request)
                view.scope(:errors).apply(request)
            end
        end
    end
end