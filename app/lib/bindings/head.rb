Pakyow::App.bindings :head do
  require "pp"
  scope :head do

    binding(:jquery) do
      location = "//code.jquery.com/jquery-2.1.4.min.js"
      unless ENV['RACK_ENV'].nil? || ENV['RACK_ENV'].length == 0
        if ENV['RACK_ENV']== "development"
          location = "/js/jquery.min.js"
        end
      end
      {
        :src => location
      }
    end # jquery

    binding(:jquery_ui) do
      location = ""
      # location = "//code.jquery.com/ui/1.11.4/jquery-ui.min.js"
      unless ENV['RACK_ENV'].nil? || ENV['RACK_ENV'].length == 0
        if ENV['RACK_ENV']== "development"
          # location = "/js/jquery-ui.js"
        end
      end
      {
        :src => location
      }
    end # jquery

    binding(:normalize) do
      location = "/css/normalize.css"
      unless ENV['RACK_ENV'].nil? || ENV['RACK_ENV'].length == 0
        if ENV['RACK_ENV']== "development"
          location = "/css/normalize.css"
        end
      end
      {
        :href => location
      }
    end # normalize

    binding(:style) do
      location = "/css/style.css"
      unless ENV['RACK_ENV'].nil? || ENV['RACK_ENV'].length == 0
        if ENV['RACK_ENV']== "development"
          location = "/css/style.css"
        end
      end
      {
        :href => location
      }
    end # main stylesheet

    binding(:override) do
      location = "/css/dev.css"
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
      location = "/js/modernizr.js"
      unless ENV['RACK_ENV'].nil? || ENV['RACK_ENV'].length == 0
        if ENV['RACK_ENV']== "development"
          location = "/js/modernizr.js"
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
        if path[1] == "people"
          if path.length > 2
            people = get_people_from_people_id(params[:people_id])
            unless people.nil?
              unless people.length < 1 || people[0].custom_url.nil?
                slug = "people/" + people[0].custom_url
              end
            end
          end
        end
      end
      href = link + slug
      {
        :href => href
      }
    end # canonical_url

    binding(:page_js) do
      p = bindable.path.split("/")
      src = "#"
      if p[1] == "people"
        if p[3] == "edit" || p[2] == "create-profile"
          src = "/js/page/people-edit.js"
        end
      elsif p[1] == "find"
        src = "/js/page/find.js"
      end
      {
        :src => src
      }
    end # page_js

    binding(:title) do
      ret = "#openHSV - Freelancers, Moonlighters, and Consultants in Huntsville, Alabama"
      path = bindable.path.split("/")
      if path.length > 1
        if path[1] == "people"
          ret = "#openHSV - Index of freelancers, moonlighters, and consultants."
        elsif path[1] == "about"
          ret = "#openHSV - About #openHSV"
        elsif path[1] == "terms"
          ret = "#openHSV - Terms of Service"
        end
      end
      
      {
        :content => ret
      }
    end

# TODO: Fix this
    binding(:description) do
      ret = "A directory of Huntsville's freelancers, moonlighters, and consultants."
      path = bindable.path.split("/")
      if path.length > 1
        if path[1] == "people"
          ret = "All of the professionals on #openHSV, sortable by industry."
        elsif path[1] == "about"
          ret = "#openHSV was built to provide a freelancer, moonlighter, and consultant resources to Huntsville's small businesses and startups."
        elsif path[1] == "terms"
          ret = "Terms of Service governing the use of #openHSV"
        end
      end
      {
        :'content' => ret
      }
    end

  end # scope :header
end # header