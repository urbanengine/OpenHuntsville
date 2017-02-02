require 'json'
Pakyow::App.routes(:api) do
  include SharedRoutes

  expand :restful, :api, '/api' do
    collection do

      expand :restful, :v1, '/v1' do
        collection do

          expand :restful, :groups, '/groups' do
            member do

              expand :restful, :events, '/events' do
                get 'schedule' do
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
                  # "end_time":"2017-01-12T03:00:00.000Z"

                  response.write('[')
                  events = Event.where("approved = true AND start_datetime > ?", DateTime.now.utc).all
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
                        "timestamp" => event.created_at.utc,
                        "group" => Group.where("id = ?", event.group_id).first.name,
                        "title" => event.name,
                        "description" => event.description,
                        "date" => event.start_datetime.utc,
                        "time_req_form" => event.start_datetime.utc,
                        "time_req" => event.start_datetime.utc,
                        "room_req" => Venue.where("id = ?", event.venue_id).first.name,
                        "start_time" => event.start_datetime.utc,
                        "end_time" => (event.start_datetime.to_time + event.duration.hours).utc
                      }
                      response.write(json.to_json)
                  }
                  response.write(']')
                end # action :list

                action :list do
                  group_events = Event.where("group_id = ?", params[:groups_id]).all
                  parent_group = Group.where("id = ?", params[:groups_id]).first
                  unless parent_group.parent_id.nil?
                    group_events.concat(Event.where("group_id = ?", parent_group.parent_id).all)
                  end
                  response.write(group_events.to_json)
                end
              end # expand :restful, :events, '/events' do

            end # member do
          end # expand :restful, :groups, '/groups' do

        end # collection do
      end # expand :restful, :v1, '/v1' do

    end # collection do
  end # expand :restful, :api, '/api' do

end # Pakyow::App.routes(:api) do
