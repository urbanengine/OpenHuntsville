module SharedRoutes
  include Pakyow::Routes

  fn :route_head do
   	view.scope(:head).apply(request)
  end

end