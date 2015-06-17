Pakyow::App.bindings :head do
  scope :head do

    binding(:colorbox) do
      location = "/assets/colorbox-master"
      unless ENV['RACK_ENV'].nil? || ENV['RACK_ENV'].length == 0
        if ENV['RACK_ENV']== "development"
          location = "http://www.hntsvll.com/assets/colorbox-master"
        end
      end
      {
        :src => location
      }
    end # colorbox

    binding(:jquery) do
      location = "http://code.jquery.com/jquery-2.1.4.min.js"
      unless ENV['RACK_ENV'].nil? || ENV['RACK_ENV'].length == 0
        if ENV['RACK_ENV']== "development"
          location = "http://code.jquery.com/jquery-2.1.4.js"
        end
      end
      {
        :src => location
      }
    end # jquery

    binding(:font_awesome) do
      location = "https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css"
      unless ENV['RACK_ENV'].nil? || ENV['RACK_ENV'].length == 0
        if ENV['RACK_ENV']== "development"
          location = "https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.css"
        end
      end
      {
        :href => location
      }
    end # font awesome

    binding(:normalize) do
      location = "http://code.jquery.com/jquery-2.1.4.min.js"
      unless ENV['RACK_ENV'].nil? || ENV['RACK_ENV'].length == 0
        if ENV['RACK_ENV']== "development"
          location = "http://www.hntsvll.com/assets/css/normalize.css"
        end
      end
      {
        :href => location
      }
    end # normalize

    binding(:style) do
      location = "http://www.hntsvll.com/assets/css/style.css"
      unless ENV['RACK_ENV'].nil? || ENV['RACK_ENV'].length == 0
        if ENV['RACK_ENV']== "development"
          location = "http://www.hntsvll.com/assets/css/style.css"
        end
      end
      {
        :href => location
      }
    end # main stylesheet

    binding(:override) do
      location = "/css/dev.min.css"
      unless ENV['RACK_ENV'].nil? || ENV['RACK_ENV'].length == 0
        if ENV['RACK_ENV']== "development"
          location = "/css/dev.css"
        end
      end
      {
        :href => location
      }
    end # override stylesheet   

    binding(:modernizr) do
      location = "http://www.hntsvll.com/assets/js/modernizr.js"
      unless ENV['RACK_ENV'].nil? || ENV['RACK_ENV'].length == 0
        if ENV['RACK_ENV']== "development"
          location = "http://www.hntsvll.com/assets/js/modernizr.js"
        end
      end
      {
        :href => location
      }
    end # override stylesheet   

    binding(:canonical) do
      path = bindable.path.split("/")
      link = "http://www.openhsv.com/"
      slug = ""
      if path.length > 1
        if path[1] == "users"
          if path.length > 2
            user = nil
            id = params[:user_id]
            if id.include? "-"
              splitname = id.split("-")
              user = User.where("lower(first_name) = ? AND lower(last_name) = ?", splitname[0],splitname[1]).first
            else
              user = User[params[:user_id]]
            end
            slug = "users/" + user.first_name.to_s.downcase + "-" + user.last_name.to_s.downcase
          end
        end
      end
      href = link + slug
      {
        :href => href
      }
    end # canonical_url      

  end # scope :header
end # header