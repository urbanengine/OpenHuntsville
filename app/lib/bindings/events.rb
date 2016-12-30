Pakyow::App.bindings :events do
	scope :events do
		restful :events

    options(:parent_group) do
      get_groups_for_logged_in_person()
    end

    binding(:parent_group) do
      { }
    end

    options(:venue) do
      get_venues()
    end

    binding(:venue) do
      { }
    end

    binding(:name) do
      {
        :content => bindable.name
      }
    end

    binding(:description) do
      {
        :content => bindable.description
      }
    end

    binding(:start_datetime) do
      {
        :content => bindable.start_datetime
      }
		end

		binding(:venue_name) do
			venue = Venue.where("id = ?", bindable.venue_id).first
			{
				:content => venue.name
			}
		end

		binding(:group_name) do
			group = Group.where("id = ?", bindable.group_id).first
			{
				:content => group.name
			}
		end

		binding(:duration) do
			{
				:content => bindable.duration.to_s + " hour(s)"
			}
		end
  end
end
