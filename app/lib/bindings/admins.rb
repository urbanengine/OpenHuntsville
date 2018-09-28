Pakyow::App.bindings :admins do
	scope :admins do
    binding(:create_group_link) do
      cssclass = "btn pull-right"
      people = get_user_from_cookies()
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
