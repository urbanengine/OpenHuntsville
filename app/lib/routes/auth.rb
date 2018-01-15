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
                #token = params[:token]
                #record = AuthToken.where('token = ? and expiration_date > ?', token, DateTime.now)

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
                else
                    pp 'hit no account exists error'
                    @errors = ['No account exists with that e-mail address.']

                    #Tyler: I think you need a redirect here to display the proper page.
                    # Also, not sure if the best user experience is to show an error page. Maybe just redirect back to the home screen and let it be?

                    #reroute router.group(:auth).path(:forgotpassword), :get
                end
            end
        end
    end
end