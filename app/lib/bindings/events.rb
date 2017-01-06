require 'date'
Pakyow::App.bindings :events do
	scope :events do
		restful :events

    options(:parent_group) do
      get_groups_for_logged_in_person()
    end

    binding(:parent_group) do
      bindable.group_id
    end

    options(:venue) do
      get_venues()
    end

    binding(:venue) do
				bindable.venue_id
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
        :content => if bindable.start_datetime then bindable.start_datetime.getlocal().strftime('%b %d, %Y %I:%M %p') else "" end
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

		binding(:approved) do
			content = if bindable.approved then "Approved" else "Unapproved" end
			people = People[session[:people]]
			if people.admin
				if bindable.approved
					content = "<p><a class='unapprove-btn' href='/events/unapprove/" + bindable.id.to_s + "'>Unapprove</a></p>"
				else
					content = "<p><a class='approve-btn' href='/events/approve/" + bindable.id.to_s + "'>Approve</a></p>"
				end
			end
			{
				:content => content
			}
		end

		binding(:edit_event_link) do
			people = People[session[:people]]
			{
			:content => "Edit Event",
			:href => '/events/' + bindable.id.to_s + '/edit'
			}
		end

		binding(:event_link) do
			people = People[session[:people]]
			{
			:content => bindable.name,
			:href => '/events/' + bindable.id.to_s
			}
		end

		binding(:approve_event_url) do
			{
				:href => '/events/approve/' + bindable.id.to_s
			}
		end
  end
end
