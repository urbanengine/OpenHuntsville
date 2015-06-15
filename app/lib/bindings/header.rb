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
    end

    binding(:jquery) do
      location = "/jquery-2.1.4.min.js"
      unless ENV['RACK_ENV'].nil? || ENV['RACK_ENV'].length == 0
        if ENV['RACK_ENV']== "development"
          location = "http://code.jquery.com/jquery-2.1.4.min.js"
        end
      end
      {
        :src => location
      }
    end

  end # scope :header
end # header