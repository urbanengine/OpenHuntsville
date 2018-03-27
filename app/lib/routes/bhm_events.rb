require 'date'
Pakyow::App.routes(:bhm) do
    include SharedRoutes

    expand :restful, :bhm_events, '/bhm_events', :before => :route_head do
        collection do
            # GET /bhm_events/manage;
            get 'manage', :before => :is_bhm_event_manager do
                events_all = []
                people = get_user_from_cookies()
                if people.nil?
                redirect '/errors/404'
                end
                cwn = Group.where("name = 'CoWorking Night: Birmingham'").first
                if cwn.nil?
                  redirect '/errors/403'
                end
                cwn_events = Group.where("name = 'CoWorking Night Events: Birmingham'").first
                if cwn_events.nil?
                  redirect '/errors/403'
                end
                events_all = Event.where('start_datetime > ? and (group_id = ? or group_id = ?)', DateTime.now.utc, cwn.id, cwn_events.id).where('archived = ?', false).all
                view.scope(:people).bind(people)
                view.scope(:bhm_events).apply(events_all)
                current_user = get_user_from_cookies()
                view.scope(:optin).apply(current_user)
                view.scope(:head).apply(request)
                view.scope(:main_menu).apply(request)
            end

            get 'approve/:bhm_events_id', :before => :is_bhm_event_admin do
                success = 'failure'
                if params[:bhm_events_id].is_number? == false
                redirect "/errors/404"
                end
                event = Event[params[:bhm_events_id]]
                if event.nil?
                redirect "/errors/404"
                end
                event.approved = true
                previous_event = Event.where("approved = true AND group_id = ? AND start_datetime < ?", event.group_id, event.start_datetime).order(:start_datetime).last
                event.save
                if request.xhr?
                success = 'success'
                else
                redirect request.referer
                end
                send success
            end

            get 'unapprove/:bhm_events_id', :before => :is_bhm_event_admin do
                success = 'failure'
                if params[:bhm_events_id].is_number? == false
                redirect "/errors/404"
                end
                event = Event[params[:bhm_events_id]]
                if event.nil?
                redirect "/errors/404"
                end
                event.approved = false
                event.save
                if request.xhr?
                success = 'success'
                else
                redirect request.referer
                end
                send success
            end
        end

        member do
            #TODO: DELETE '/bhm_events/:bhm_events_id' route. This is a workaround
            # GET ''/bhm_events/:bhm_events_id/delete'
            get 'delete' do
                if params[:bhm_events_id].is_number? == false
                redirect "/errors/404"
                end
                event = Event.where("id = ?", params[:bhm_events_id]).first
                if event.nil?
                redirect "/errors/404"
                end
                isNotSiteAdmin = !logged_in_user_is_bhm_admin_or_site_admin()
                if event.approved && isNotSiteAdmin
                redirect "/errors/404"
                end
                if logged_in_user_is_manager_of_event(event) == false
                redirect "/errors/403"
                end
                event_start_datetime = event.start_datetime
                event_group_id = event.group_id
                event_is_approved = event.approved
                event.archived = true
                event.save
                redirect '/bhm_events/manage'
            end
        end

        # GET /bhm_events; same as Index
        action :list do
            people = get_user_from_cookies()
            if people.nil?
                redirect '/errors/404'
            end
            events_all = []
            people.groups().each { |group|
                events = Event.where('group_id = ?', group.id).all
                events.each { |event|
                events_all.push(event)
                }
            }
            view.scope(:bhm_events).apply(events_all)
            current_user = get_user_from_cookies()
            view.scope(:optin).apply(current_user)
            view.scope(:head).apply(request)
            view.scope(:main_menu).apply(request)
        end

        # GET /bhm_events/:bhm_events_id
        action :show do
            people = get_user_from_cookies()
            if people.nil?
                redirect '/errors/404'
            end
            if params[:bhm_events_id].is_number? == false
                redirect "/errors/404"
            end
            event = Event.where("id = ?", params[:bhm_events_id]).first
            if event.nil?
                redirect "/errors/404"
            end
            view.scope(:people).bind(people)
            view.scope(:bhm_events).apply([event, event])
            current_user = get_user_from_cookies()
            view.scope(:optin).apply(current_user)
            view.scope(:head).apply(request)
            view.scope(:main_menu).apply(request)
        end

        # GET '/bhm_events/new'
        action :new, :before => :is_bhm_event_manager do
            people = get_user_from_cookies()
            if people.nil?
                redirect '/errors/404'
            end
            view.scope(:bhm_events).with do
                bind(Event.new)
            end
            view.scope(:people).bind(people)
            current_user = get_user_from_cookies()
            view.scope(:optin).apply(current_user)
            view.scope(:head).apply(request)
            view.scope(:main_menu).apply(request)
        end

        #POST '/bhm_events/'
        action :create, :before => :is_bhm_event_manager do
            people = get_user_from_cookies()
            if people.nil?
                redirect '/errors/404'
            end
            puts "here"
            parsed_time = DateTime.strptime(params[:bhm_events][:start_datetime] + "-0500", '%b %d, %Y %I:%M %p %Z')
            previous_event = Event.where("approved = true AND group_id = ? AND start_datetime < ?", params[:bhm_events][:parent_group].to_i, parsed_time.to_datetime.utc).order(:start_datetime).last
            group = Group.where("id = ?", params[:bhm_events][:parent_group].to_i).first
            c_params =
                {
                "name" => params[:bhm_events][:name],
                "summary" => params[:bhm_events][:summary],
                "description" => params[:bhm_events][:description],
                "group_id" => params[:bhm_events][:parent_group].to_i,
                "start_datetime" => parsed_time.to_datetime.utc,
                "duration" => params[:bhm_events][:duration].to_i,
                "venue_id" => params[:bhm_events][:venue].to_i,
                "approved" => if logged_in_user_is_bhm_admin_or_site_admin() then true else false end,
                "parent_id" => if params[:bhm_events][:parent_event_selector].blank? then "" else params[:bhm_events][:parent_event_selector].to_i end,
                "flyer_category" => if params[:bhm_events][:flyer_category].nil? || params[:bhm_events][:flyer_category].empty? then group.flyer_category else params[:bhm_events][:flyer_category] end,
                "flyer_fa_icon" => if params[:bhm_events][:flyer_fa_icon].nil? || params[:bhm_events][:flyer_fa_icon].empty? then group.flyer_fa_icon else params[:bhm_events][:flyer_fa_icon] end,
                "created_by" => people.id,
                "updated_by" => people.id
                }
            event = Event.new(c_params)
            event.save
            redirect '/bhm_events/manage'
        end

        #PATCH '/bhm_events/:bhm_events_id'
        action :update, :before => :is_bhm_event_manager do
            people = get_user_from_cookies()
            if people.nil?
                redirect '/errors/404'
            end
            if params[:bhm_events][:id].is_number? == false
                redirect "/errors/404"
            end
            event = Event.where("id = ?", params[:bhm_events][:id]).first
            if event.nil?
                redirect "/errors/404"
            end
            if logged_in_user_is_manager_of_event(event) == false
                redirect "/errors/403"
            end
            parsed_datetime = DateTime.strptime(params[:bhm_events][:start_datetime] + "-0500", '%b %d, %Y %I:%M %p %Z')
            venue_id = params[:bhm_events][:venue].to_i
            minutes_between_old_and_new_date = (((parsed_datetime - event.start_datetime.to_datetime)*24*60).to_i).abs

            if logged_in_user_is_bhm_admin_or_site_admin() == false && (minutes_between_old_and_new_date > 0.99 || venue_id != event.venue_id)
                event.approved = false
            end
            event.name = params[:bhm_events][:name]
            event.description = params[:bhm_events][:description]
            event.summary = params[:bhm_events][:summary]
            event.group_id = params[:bhm_events][:parent_group].to_i
            event.start_datetime = parsed_datetime.to_datetime.utc
            event.duration = params[:bhm_events][:duration].to_i
            if params[:bhm_events][:parent_event_selector].blank?
                event.parent_id = nil
            else
                event.parent_id = params[:bhm_events][:parent_event_selector].to_i
            end
            event.venue_id = venue_id
            event.flyer_category = params[:bhm_events][:flyer_category]
            event.flyer_fa_icon = params[:bhm_events][:flyer_fa_icon]
            event.updated_by = people.id
            event.save
            redirect '/bhm_events/manage'
        end

        # GET '/bhm_events/:bhm_events_id/edit'
        action :edit, :before => :is_bhm_event_manager do
            people = get_user_from_cookies()
            if people.nil?
                redirect '/errors/404'
            end
            if params[:bhm_events_id].is_number? == false
                redirect "/errors/404"
            end
            event = Event.where("id = ?", params[:bhm_events_id]).first
            if event.nil?
                redirect "/errors/404"
            end
            if logged_in_user_is_manager_of_event(event) == false
                redirect "/errors/403"
            end
            view.scope(:bhm_events).bind([event, event, event])
            view.scope(:people).bind(people)
            current_user = get_user_from_cookies()
            view.scope(:optin).apply(current_user)
            view.scope(:head).apply(request)
            view.scope(:main_menu).apply(request)
        end
    end
end
