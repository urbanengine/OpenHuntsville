require 'json'
require 'date'
Pakyow::App.routes(:api) do
  include SharedRoutes

  expand :restful, :api, '/api' do
    collection do

      expand :restful, :v1, '/v1' do
        collection do

          expand :restful, :groups, '/groups' do
            member do

              expand :restful, :events, '/events' do
                action :list do
                  if request.xhr?
                    # respond to Ajax request
                    nextThursday = Date.parse('Thursday')
                    delta = nextThursday > Date.today ? 0 : 7
                    nextThursday = nextThursday + delta

                    people = People[cookies[:people]]
                    if people.nil? == false && people.admin?
                      time_limit = DateTime.now.utc
                    else      
                      time_limit = if (nextThursday - Date.today) < 4 then nextThursday else DateTime.now.utc end
                    end

                    group_events = Event.where("group_id = ? AND start_datetime > ?", params[:groups_id], time_limit).all
                    parent_group = Group.where("id = ?", params[:groups_id]).first
                    unless parent_group.parent_id.nil?
                      group_events.concat(Event.where("group_id = ? AND start_datetime > ?", parent_group.parent_id, time_limit).all)
                    end
                    response.write(group_events.to_json)
                  else
                    # respond to normal request
                    redirect '/errors/403'
                  end
                end
              end # expand :restful, :events, '/events' do

            end # member do
          end # expand :restful, :groups, '/groups' do


          get 'cwn_flyer' do
            # "approved":true,
            # "cwn":88,
            # "timestamp":"2017-01-09T20:27:22.161Z",
            # "group":"Designer's Corner",
            # "title":"CoWorking Night Tshirt Competition",
            # "description":"Come in to get some last minute ideas for your entry to the CoWorking Night Tshirt competition! ",
            # "date":"2017-01-11T06:00:00.000Z",
            # "time_req_form":"8:00 PM",
            # "time_req":"1899-12-31T01:48:52.000Z",
            # "room_req":"Milky Way Row",
            # "start_time":"2017-01-12T02:00:00.000Z",
            # "end_time":"2017-01-12T03:00:00.000Z",
            # "category":"Programming",
            # "icon":"terminal"

            #For now, we'll keep this only exposed for cwn
            cwn = Group.where("name = 'CoWorking Night'").first
            if cwn.nil?
              redirect '/errors/403'
            end

            #Now lets get all the events for this group. This means all of this group's events and its event's children
            next_cwn_event = Event.where("approved = true AND start_datetime > ? AND group_id = ?", DateTime.now.utc, cwn.id).order(:start_datetime).first
            events = get_child_events_for_event(next_cwn_event)
            response.write('[')
            first_time = true
            events.each { |event|
              if first_time == true
                first_time = false
              else
                response.write(',')
              end
              json =
                {
                  "approved" => event.approved,
                  "cwn" => next_cwn_event.instance_number,
                  "timestamp" => event.created_at.utc,
                  "group" => Group.where("id = ?", event.group_id).first.name,
                  "title" => event.name,
                  "description" => event.summary,
                  "date" => event.start_datetime.utc,
                  "time_req_form" => event.start_datetime.utc,
                  "time_req" => event.start_datetime.utc,
                  "room_req" => Venue.where("id = ?", event.venue_id).first.name,
                  "start_time" => event.start_datetime.utc,
                  "end_time" => (event.start_datetime.to_time + event.duration.hours).utc,
                  "category" => event.flyer_category,
                  "icon" => event.flyer_fa_icon
                }
                response.write(json.to_json)
            }
            response.write(']')
          end # get 'cwn_flyer'
        end # collection do
      end # expand :restful, :v1, '/v1' do

    end # collection do
  end # expand :restful, :api, '/api' do

end # Pakyow::App.routes(:api) do
