Pakyow::App.routes(:pageviews) do
  include SharedRoutes

  expand :restful, :pageviews, '/pageviews' do

    collection do
      post '/' do
        success = 'failure'
        if request.xhr?
          pp params
        else
          # Show 401 error if not Ajax request.
          handle 401
        end
        send success
        # pp request
      end # '/clicks/people/:click'

    end # collection do
  
  end
end
