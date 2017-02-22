Pakyow::App.bindings :admins do
	scope :admins do
    binding(:create_group_link) do
      cssclass = "btn pull-right"
      people = People[cookies[:people]]
      if people.nil? || people.admin.nil? || people.admin == false
        cssclass = "hide"
      end
      {
        :class => cssclass,
        :content => "Create Group",
        :href => '/groups/new'
      }
    end
  end
end
