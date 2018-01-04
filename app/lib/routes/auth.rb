# require 'securerandom'
# SecureRandom.uuid

Pakyow::App.routes do
    include SharedRoutes

    expand :restful, :auth_token, '/auth', :before => :route_head do
        collection do
            
            get '/' do
                view.scope(:head).apply(request)
            end

            get 'verifyemail/:token' do
                token = params[:token]
                #record = AuthToken.where('token = ? and expiration_date > ?', token, DateTime.now)
                
                #unless record.nil?
                    # token exists in the database and has not yet expired

                #end

                #view.scope(:head).apply(request)
                #view.scope(:main_menu).apply(request)
                #view.scope(:auth_token).apply(request)
            end

            get 'forgotpassword' do
                #token = params[:token]
                #record = AuthToken.where('token = ? and expiration_date > ?', token, DateTime.now)

                #unless record.nil?
                    # token exists in the database and has not yet expired

                #end

                view.scope(:head).apply(request)
                #view.scope(:main_menu).apply(request)
                #view.scope(:auth_token).apply(request)
            end
        end
    end
end