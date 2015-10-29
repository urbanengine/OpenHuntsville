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
end
