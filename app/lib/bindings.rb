Pakyow::App.bindings do
	scope :header do
		restful :header
		binding(:title) do
			{
				:content => "content"
			}
		end
	end
	scope :note do
		restful :note
		binding(:title) do
			{
				:content => "content"
			}
		end
	end
	scope :user do
		restful :user

		binding(:first_name) do
			{
				:content => bindable.first_name
			}
		end

		binding(:last_name) do
			{
				:content => bindable.last_name
			}
		end

		binding(:company) do
			{
				:content => bindable.company
			}
		end

		binding(:twitter_link) do
			show = "hide"
			link = "#"
			if bindable.nil? || bindable.twitter.nil? || bindable.twitter.length ==	 0

			else
				show = "show"
				link = "http://www.twitter.com/" + bindable.twitter
			end
			{
				:href => link,
				:class => show
			}
		end

		binding(:linkedin_link) do
			show = "hide"
			link = "#"
			if bindable.nil? || bindable.linkedin.nil? || bindable.linkedin.length == 0
				
			else
				show = "show"
				link = bindable.linkedin
			end
			{
				:href => link,
				:class => show
			}
		end

		binding(:url_link) do
			show = "hide"
			link = "#"
			if bindable.nil? || bindable.url.nil? || bindable.url.length == 0
				
			else
				show = "show"
				link = bindable.url
			end
			{
				:href => link,
				:class => show
			}
		end

		binding(:twitter) do
			{
				:content => bindable.twitter
			}
		end

		binding(:linkedin) do
			{
				:content => bindable.linkedin
			}
		end

		binding(:url) do
			{
				:content => bindable.url
			}
		end

		binding(:other_info) do
			{
				:content => bindable.other_info
			}
		end

		binding(:email_link) do
			if bindable.email.nil?
				bindable.email = "webmaster@openhsv.com"
			end
			{
				:content => bindable.email,
				:href => "mailto:" + bindable.email
			}
		end

		binding(:email) do
			if bindable.email.nil?
				bindable.email = "email"
			end
			{
				:content => bindable.email
			}
		end

		binding(:categories_string) do
			{
				:content => bindable.categories_string
			}
		end

		binding(:category_one) do
			puts "/app/lib/bindings.rb :: category_one :: " + bindable.categories_string.to_s
			cat = ""
			unless bindable.categories_string.nil?
				cat = getVal(bindable.categories_string,0)
			end
			{
				:content => cat
			}
		end

		binding(:category_two) do
			puts "/app/lib/bindings.rb :: category_two :: " + bindable.categories_string.to_s
			cat = ""
			unless bindable.categories_string.nil?
				cat = getVal(bindable.categories_string,1)
			end
			{
				:content => cat
			}
		end

		binding(:category_three) do
			puts "/app/lib/bindings.rb :: category_three :: " + bindable.categories_string.to_s
			cat = ""
			unless bindable.categories_string.nil?
				cat = getVal(bindable.categories_string,2)
			end
			{
				:content => cat
			}
		end

		binding(:image_url) do
			bindable.image_url
		end

		binding(:image) do
			name = ""
			unless bindable.nil? || bindable.first_name.nil? || bindable.last_name.nil?
				name = bindable.first_name + " " + bindable.last_name
			end
			{
				:src => bindable.image_url,
				:title =>  name,
				:alt => name
			}
		end

    end

    scope :session do
    	restful :session
    end
end
