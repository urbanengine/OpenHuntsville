Pakyow::App.bindings :main_menu do
  require "pp"
  scope :main_menu do
  restful :main_menu
  	binding(:first_container) do
  		{
  		}
  	end
	
	binding(:people_link) do
		css_class = ""
		splat = request.path.split("/")
		unless splat[1].nil? || splat[1].length == 0
			if splat[1] == "people"
				unless splat[2].nil? && splat[2] == "new"

				else
					css_class = "selected"
				end
			end
		end
  		{
  			:class => css_class
  		}
  	end

	binding(:about_link) do
  		css_class = ""
		splat = request.path.split("/")
		unless splat[1].nil? || splat[1].length == 0
			if splat[1] == "about"
				css_class = "selected"
			end
		end
  		{
  			:class => css_class
  		}
  	end

	binding(:feedback_link) do
  		{
  		}
  	end

	binding(:login_container) do
  		{
  		}
  	end

	binding(:create_profile_link) do
  		css_class = ""
		splat = request.path.split("/")
		unless splat[1].nil? || splat[1].length == 0
			if splat[1] == "people"
				css_class = "selected"
			end
		end
  		{
  			:class => css_class
  		}
  	end

	binding(:login_link) do
  		css_class = ""
		splat = request.path.split("/")
		unless splat[1].nil? || splat[1].length == 0
			if splat[1] == "sessions"
				css_class = "selected"
			end
		end
  		{
  			:class => css_class
  		}
  	end	
  end
end