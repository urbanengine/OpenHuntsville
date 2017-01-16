require 'json'
Pakyow::App.routes(:api) do
  include SharedRoutes

  expand :restful, :api, '/api' do
    collection do

      expand :restful, :v1, '/v1' do
        collection do

          expand :restful, :events, '/events' do
            action :list do
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
                    "timestamp" => event.start_datetime.in_time_zone("Central Time (US & Canada)").to_datetime.rfc3339(3),
                    "group" => Group.where("id = ?", event.group_id).first.name,
                    "title" => event.name,
                    "description" => event.description,
                    "date" => event.start_datetime.in_time_zone("Central Time (US & Canada)").to_date.rfc3339,
                    "time_req_form" => event.start_datetime.in_time_zone("Central Time (US & Canada)").strftime('%I:%M %p'),
                    "time_req" => event.start_datetime.in_time_zone("Central Time (US & Canada)").to_datetime.rfc3339(3),
                    "room_req" => Venue.where("id = ?", event.venue_id).first.name,
                    "start_time" => event.start_datetime.in_time_zone("Central Time (US & Canada)").to_datetime.rfc3339(3),
                    "end_time" => (event.start_datetime.to_time + 1).to_datetime.in_time_zone("Central Time (US & Canada)").to_datetime.rfc3339(3)
                  }
                  response.write(json.to_json)
              }
              response.write(']')
            end
          end

        end
      end

    end
  end
end
