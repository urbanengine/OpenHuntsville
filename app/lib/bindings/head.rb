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

    binding(:canonical) do
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

      puts ":modernizr"
      location = "http://www.hntsvll.com/assets/js/modernizr.js"
      unless ENV['RACK_ENV'].nil? || ENV['RACK_ENV'].length == 0
        if ENV['RACK_ENV']== "development"
          location = "http://www.hntsvll.com/assets/js/modernizr.js"
        end
      end
      {
        :href => location
      }
    end # modernizr

  end # scope :header
end # header