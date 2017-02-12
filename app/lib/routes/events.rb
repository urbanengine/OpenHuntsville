require 'date'
Pakyow::App.routes(:events) do
  include SharedRoutes

  expand :restful, :events, '/events', :before => :route_head do

    collection do
      # GET /events/manage;
      get 'manage', :before => :is_event_manager do
        events_all = []
  			people = People[session[:people]]
        if people.nil?
          redirect '/errors/404'
        end
        if people.admin
          events_all = Event.where('start_datetime > ?', DateTime.now.utc).all
        else
          people.groups().each { |group|
            events = Event.where('group_id = ?', group.id).where('start_datetime > ?', DateTime.now.utc).all
            events.each { |event|
              events_all.push(event)
            }
          }
        end
        view.scope(:people).bind(people)
        view.scope(:events).apply(events_all)
        current_user = People[cookies[:people]]
        view.scope(:optin).apply(current_user)
        view.scope(:head).apply(request)
        view.scope(:main_menu).apply(request)
      end

      get 'approve/:events_id', :before => :is_admin_check do
        success = 'failure'
        approve_me = Event[params[:events_id]]
        approve_me.approved = true
        previous_event = Event.where("approved = true AND group_id = ? AND start_datetime < ?", approve_me.group_id, approve_me.start_datetime).order(:start_datetime).last
        instance_number = 1
        unless previous_event.nil?
          #TODO: Need to rethink this. There could be a bug when the approval doesn't happen in order...
          #      Same thing could happen with event creation if it doesn't happen sequentially; sigh
          instance_number = previous_event.instance_number + 1
        end
        approve_me.instance_number = instance_number
        approve_me.save
        if request.xhr?
          success = 'success'
        else
          redirect request.referer
        end
        send success
      end

      get 'unapprove/:events_id', :before => :is_admin_check do
        success = 'failure'
        approve_me = Event[params[:events_id]]
        approve_me.approved = false
        approve_me.save
        if request.xhr?
          success = 'success'
        else
          redirect request.referer
        end
        send success
      end
    end

    member do
      #TODO: DELETE '/events/:events_id' route. This is a workaround
      # GET ''/events/:events_id/delete'
      get 'delete' do
        event = Event.where("id = ?", params[:events_id]).first
        if logged_in_user_is_manager_of_event(event) == false
          redirect "/errors/403"
        end
        event.destroy
        redirect '/events/manage'
      end
    end

    # GET /events; same as Index
    action :list do
      people = People[session[:people]]
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
      view.scope(:events).apply(events_all)
      current_user = People[cookies[:people]]
      view.scope(:optin).apply(current_user)
      view.scope(:head).apply(request)
      view.scope(:main_menu).apply(request)
    end

    # GET /events/:events_id
    action :show do
      people = People[session[:people]]
      if people.nil?
        redirect '/errors/404'
      end
      event = Event.where("id = ?", params[:events_id]).first
      view.scope(:people).bind(people)
      view.scope(:events).apply([event, event])
      current_user = People[cookies[:people]]
      view.scope(:optin).apply(current_user)
      view.scope(:head).apply(request)
      view.scope(:main_menu).apply(request)
    end

    # GET '/events/new'
    action :new, :before => :is_event_manager do
      people = People[session[:people]]
      if people.nil?
        redirect '/errors/404'
      end
      view.scope(:events).with do
        bind(Event.new)
      end
      view.scope(:people).bind(people)
      current_user = People[cookies[:people]]
      view.scope(:optin).apply(current_user)
      view.scope(:head).apply(request)
      view.scope(:main_menu).apply(request)
    end

    #POST '/events/'
    action :create, :before => :is_event_manager do
      people = People[session[:people]]
      if people.nil?
        redirect '/errors/404'
      end
      parsed_time = DateTime.strptime(params[:events][:start_datetime] + "-0600", '%b %d, %Y %I:%M %p %Z')
      previous_event = Event.where("approved = true AND group_id = ? AND start_datetime < ?", params[:events][:parent_group].to_i, parsed_time.to_datetime.utc).order(:start_datetime).last
      instance_number = 1
      unless previous_event.nil?
        instance_number = previous_event.instance_number + 1
      end
      c_params =
        {
          "name" => params[:events][:name],
          "description" => params[:events][:description],
          "group_id" => params[:events][:parent_group].to_i,
          "start_datetime" => parsed_time.to_datetime.utc,
          "duration" => params[:events][:duration].to_i,
          "venue_id" => params[:events][:venue].to_i,
          "approved" => if people.admin then true else false end,
          "instance_number" => if people.admin then instance_number else nil end,
          "parent_id" => if params[:events][:parent_event_selector].blank? then nil else params[:events][:parent_event_selector].to_i end
        }
      event = Event.new(c_params)
      event.save
      redirect '/events/manage'
    end

    #PATCH '/events/:events_id'
    action :update, :before => :is_event_manager do
      people = People[session[:people]]
      if people.nil?
        redirect '/errors/404'
      end
      event = Event.where("id = ?", params[:events][:id]).first
      if logged_in_user_is_manager_of_event(event) == false
        redirect "/errors/403"
      end
      parsed_datetime = DateTime.strptime(params[:events][:start_datetime] + "-0600", '%b %d, %Y %I:%M %p %Z')
      venue_id = params[:events][:venue].to_i
      minutes_between_old_and_new_date = (((parsed_datetime - event.start_datetime.to_datetime)*24*60).to_i).abs
      if people.admin == false && (minutes_between_old_and_new_date > 0.99 || venue_id != event.venue_id)
        event.approved = false
      end
      event.name = params[:events][:name]
      event.description = params[:events][:description]
      event.group_id = params[:events][:parent_group].to_i
      event.start_datetime = parsed_datetime.to_datetime.utc
      event.duration = params[:events][:duration].to_i
      unless params[:events][:parent_event].blank?
        event.parent_id = params[:events][:parent_event].to_i
      end
      event.venue_id = venue_id
      event.save
      redirect '/events/manage'
    end

    # GET '/events/:events_id/edit'
    action :edit, :before => :is_event_manager do
      people = People[session[:people]]
      if people.nil?
        redirect '/errors/404'
      end
      event = Event.where("id = ?", params[:events_id]).first
      if logged_in_user_is_manager_of_event(event) == false
        redirect "/errors/403"
      end
      view.scope(:events).bind([event, event])
      view.scope(:people).bind(people)
      current_user = People[cookies[:people]]
      view.scope(:optin).apply(current_user)
      view.scope(:head).apply(request)
      view.scope(:main_menu).apply(request)
    end
  end
end
