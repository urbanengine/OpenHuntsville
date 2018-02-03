Pakyow::App.routes(:pageviews) do
  include SharedRoutes

  expand :restful, :pageviews, '/pageviews' do

    collection do
      post '/' do
        success = 'failure'
        if request.xhr?
        else
          # Show 401 error if not Ajax request.
          handle 401
        end
        send success
      end # '/clicks/people/:click'

    end # collection do
  
  end
end
