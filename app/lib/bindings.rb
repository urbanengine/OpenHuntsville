Pakyow::App.bindings do

    scope :session do
    	restful :session
    end

    scope :search_results do
    	restful :search_results

    	binding(:search_terms) do
    		bindable.search_terms
    	end

    	binding(:found_results) do
    		bindable.number_results
    	end

    end

    scope :optin do

      binding(:container) do
        clazz = 'hide'
        p "here"
        unless bindable.nil?
          if bindable.opt_in_time.nil?
            clazz = 'show'
          end
        end
        {
          :class => clazz
        }
      end #binding(:container) do

    end # scope :optin do
end
