require 'date'
Pakyow::App.routes(:events) do
  include SharedRoutes

  expand :restful, :events, '/events', :before => :route_head do

    collection do
      # GET /events/manage;
      get 'manage' do
        events_all = []
  			people = People[session[:people]]
        if people.nil?
          redirect '/errors/404'
        end
        people.groups().each { |group|
          events = Event.where('group_id = ?', group.id).all
          events.each { |event|
            events_all.push(event)
          }
        }
        view.scope(:people).bind(people)
        view.scope(:events).apply(events_all)
        view.scope(:head).apply(request)
        view.scope(:main_menu).apply(request)
      end

      get '/dashboard', :before => :is_admin_check do
        unapproved = Event.where(:approved=>true).invert.all
        view.scope(:events).apply(unapproved)
        view.scope(:head).apply(request)
        view.scope(:main_menu).apply(request)
      end

      get 'approve/:events_id', :before => :is_admin_check do
        success = 'failure'
        approve_me = Event[params[:events_id]]
        approve_me.approved = true
        approve_me.save
        if request.xhr?
          success = 'success'
        else
          redirect request.referer
        end
        send success
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
      view.scope(:head).apply(request)
      view.scope(:main_menu).apply(request)
    end

    # GET '/events/new'
    action :new do
      people = People[session[:people]]
      if people.nil?
        redirect '/errors/404'
      end
      view.scope(:events).with do
        bind(Event.new)
      end
      view.scope(:people).bind(people)
      view.scope(:head).apply(request)
      view.scope(:main_menu).apply(request)
    end

    #POST '/events/'
    action :create do
      people = People[session[:people]]
      if people.nil?
        redirect '/errors/404'
      end
      parsed_time = DateTime.strptime(params[:events][:start_datetime] + "Central Time (US & Canada)", '%b %d, %Y %I:%M %p %Z')
      c_params =
        {
          "name" => params[:events][:name],
          "description" => params[:events][:description],
          "group_id" => params[:events][:parent_group].to_i,
          "start_datetime" => parsed_time, #Note: This is stored in the db without timezone applied (so CST -6hrs)
          "duration" => 1, #TODO: Expost this to users through the form
          "venue_id" => params[:events][:venue].to_i,
          "approved" => false
        }
      event = Event.new(c_params)
      event.save
      redirect '/events/manage'
    end

    #PATCH '/events/:events_id'
    action :update do
      people = People[session[:people]]
      if people.nil?
        redirect '/errors/404'
      end
      event = Event.where("id = ?", params[:events][:id]).first
      parsed_time = DateTime.strptime(params[:events][:start_datetime] + "Central Time (US & Canada)", '%b %d, %Y %I:%M %p %Z')
      event.name = params[:events][:name]
      event.description = params[:events][:description]
      event.group_id = params[:events][:parent_group].to_i
      event.start_datetime = parsed_time
      event.duration = 1 #TODO: Expose this to users through the form
      event.venue_id = params[:events][:venue].to_i
      event.save
      redirect '/events/manage'
    end

    # GET '/events/:events_id/edit'
    action :edit do
      people = People[session[:people]]
      if people.nil?
        redirect '/errors/404'
      end
      event = Event.where("id = ?", params[:events_id]).first
      view.scope(:events).bind([event, event])
      view.scope(:people).bind(people)
      view.scope(:head).apply(request)
      view.scope(:main_menu).apply(request)
    end
  end
end
