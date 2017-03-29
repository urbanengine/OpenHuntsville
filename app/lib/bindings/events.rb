require 'date'
require 'active_support/all'
Pakyow::App.bindings :events do
	scope :events do
		restful :events

		binding(:should_restrict_event_starttime) do
			people = People[cookies[:people]]
			{
				:content => if (!people.nil? && !people.admin.nil? && people.admin) then "false" else "true" end
			}
		end

    options(:parent_group) do
      get_groups_for_logged_in_person()
    end

    binding(:parent_group) do
      bindable.group_id
    end

		options(:duration) do
			opts = [[]]
			opts << [1, "1 hour"]
			opts << [2, "2 hours"]
			opts << [3, "3 hours"]
			opts << [4, "4 hours"]
			opts << [5, "5 hours"]
			opts
		end

    binding(:duration) do
      bindable.duration
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

    binding(:summary) do
      {
        :content => bindable.summary
      }
    end

    binding(:start_datetime) do
      {
        :content => if bindable.start_datetime then bindable.start_datetime.in_time_zone("Central Time (US & Canada)").strftime('%b %d, %Y %I:%M %p') else "" end
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

		binding(:parent_event_li) do
			css_class = "hide"
			unless bindable.group_id.nil?
				css_class = ""
			end
			{
				:class => css_class
			}
		end

		options(:parent_event_selector) do
			get_events_for_coworkingnight()
		end

		binding(:parent_event_selector) do
			unless bindable.parent_id.nil?
				bindable.parent_id
			end
		end

		binding(:duration_text) do
			hours_string = if bindable.duration > 1 then " hours" else " hour" end
			{
				:content => bindable.duration.to_s + hours_string
			}
		end

		binding(:approved) do
			content = if bindable.approved then "Approved" else "Pending" end
			people = People[cookies[:people]]
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
			people = People[cookies[:people]]
			{
			:content => "Edit Event",
			:href => '/events/' + bindable.id.to_s + '/edit'
			}
		end

		binding(:delete_event_link) do
			cssclass = "delete-btn"
			people = People[cookies[:people]]
			isNotSiteAdmin = people != nil && people.admin != nil && people.admin == false
			if bindable.approved && isNotSiteAdmin
				cssclass = "hide"
			else
				splat = request.path.split("/")
				# Either /events/new, or /events/:events_id/edit
				unless splat[1].nil? || splat[1].length == 0
					if splat[1] == "events"
						unless splat[2].nil? || splat[2].length == 0
							if splat[2] == "new"
								cssclass = "hide"
							end
						end
					end
				end
			end
			{
			:content => "Delete",
			:href => '/events/' + bindable.id.to_s + '/delete',
			:class => cssclass
			}
		end

		binding(:event_link) do
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

		binding(:parent_event) do
			content = "(Empty)"
			unless bindable.parent_id.nil?
				parent_event = Event.where("id = ?", bindable.parent_id).first
				content = parent_event.name
			end
			{
				:content => content
			}
		end

		binding(:websiteadmin_fieldset) do
			visible = "hide"
			people = People[cookies[:people]]
			isSiteAdmin = people != nil && people.admin != nil && people.admin == true
			if isSiteAdmin
				visible = "show"
			end
			{
			:class => visible
			}
		end

		binding(:flyer_category) do
			{
			:content => bindable.flyer_category
			}
		end

		binding(:flyer_fa_icon) do
			{
			:content => bindable.flyer_fa_icon
			}
		end

		binding(:created_by_updated_by) do
			creator = People.where("id = ?", bindable.created_by).first
			updator = People.where("id = ?", bindable.updated_by).first
			content = ""
			unless creator.nil? || updator.nil?
				content = "This event was created by " + creator.first_name + " " + creator.last_name + " on " + bindable.created_at.in_time_zone("Central Time (US & Canada)").strftime('%b %d, %Y %I:%M %p') + " and updated by " + updator.first_name + " " + updator.last_name + " on " + bindable.updated_at.in_time_zone("Central Time (US & Canada)").strftime('%b %d, %Y %I:%M %p')
			end
			{
				:content => content
			}
		end
  end
end
