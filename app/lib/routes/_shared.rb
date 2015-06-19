module SharedRoutes
  include Pakyow::Routes

  fn :route_head do
  	puts request
  	puts view
  	puts :head
  	unless request.nil? || view.nil?
	  # view.scope(:head).apply(request)
    end
  end

end