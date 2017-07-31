require 'pp'
Pakyow::App.bindings :groups do
	scope :groups do
		restful :groups

		options(:category_one) do
			get_nested_category_id_and_category_name()
		end
		options(:category_two) do
			get_nested_category_id_and_category_name()
		end
		options(:category_three) do
			get_nested_category_id_and_category_name()
		end

		options(:add_group_admin) do
			splat = request.path.split("/")
			unless splat[1].nil? || splat[1].length == 0
				if splat[1] == "groups"
					unless splat[2].nil? || splat[2].length == 0
						unless splat[2] == "new"
							get_people_to_add_as_group_admin(splat[2])
						end
					end
				end
			end
		end

		binding(:add_group_admin) do
		end

		binding(:id) do
			{
			:value => bindable.id
			}
		end

		binding(:name) do
			{
				:content => bindable.name
			}
		end

		binding(:url_link) do
			show = "hide"
			title = ""
			link = ""
			content = ""
			if cookies[:people].nil?
					show = "show"
					title = "Log in to view " + bindable.name + "'s Website"
					link = "/login"
					content = "Log in to view"
			else
				content = "Website"
				if bindable.nil? || bindable.url.nil? || bindable.url.length == 0

				else
					show = "show"
					link = "/clicks/groups/" + bindable.id + "/url" #TODO: David: This doesn't work current. Need to alter code for group logic
				end

				unless bindable.name.nil?
					title = bindable.name + "'s URL"
				end
			end
			{
				:target => "_blank",
				:href => link,
				:class => show,
				:title => title,
				:content => content
			}
		end

		binding(:categories_string) do
			{
				:content => bindable.categories_string
			}
		end

		binding (:category_one_link) do
			href = ""
			content = ""
			unless bindable.nil? || bindable.categories.nil?
				jsn = bindable.categories.to_s
				unless jsn.nil? || jsn.length == 0
					array = JSON.parse(jsn)

					unless array[0].nil? || array[0].length == 0
					    category = Category[array[0]]
						href = "#"
						content = category.category
						href = category.url
					end
				end
			end
			{
				:href => href,
				:content => content
			}
		end

		binding (:category_two_link) do
			href = ""
			content = ""
			unless bindable.nil? || bindable.categories.nil?
				jsn = bindable.categories.to_s
				unless jsn.nil? || jsn.length == 0
					array = JSON.parse(jsn)
					unless array[1].nil? || array[1].length == 0

					    category = Category[array[1]]
						href = "#"
						content = category.category
						href = category.url
					end
				end
			end
			{
				:href => href,
				:content => content
			}
		end

		binding (:category_three_link) do
			href = ""
			content = ""
			unless bindable.nil? || bindable.categories.nil?
				jsn = bindable.categories.to_s
				unless jsn.nil? || jsn.length == 0
					array = JSON.parse(jsn)

					unless array[2].nil? || array[2].length == 0
					   category = Category[array[2]]
						href = "#"
						content = category.category
						href = category.url
					end
				end
			end
			{
				:href => href,
				:content => content
			}
		end

		binding(:category_one) do
			bindable.category_one_id
		end

		binding(:category_two) do
			bindable.category_two_id
		end

		binding(:category_three) do
			bindable.category_three_id
		end

		binding(:category_spacer_one) do
			log_debug("/app/lib/bindings.rb :: category_spacer_one :: ", bindable.categories_string.to_s)
			cat = ""
			unless bindable.categories.nil?
				jsn = bindable.categories.to_s
				array = JSON.parse(jsn)
			   if array.length > 1 && array[1].length > 1
			   	cat =  "&nbsp;/&nbsp;"
			   end
			end
			{
				:content => cat
			}
		end

		binding(:category_spacer_two) do
			log_debug("/app/lib/bindings.rb :: category_spacer_one :: ", bindable.categories_string.to_s)
			cat = ""
			unless bindable.categories.nil?
				jsn = bindable.categories.to_s
				array = JSON.parse(jsn)
			   if array.length > 2 && array[2].length > 1
			   	cat =  "&nbsp;/&nbsp;"
			   end
			end
			{
				:content => cat
			}
		end

		#binding(:image_url) do
		#	bindable.image_url
		#end

		binding(:image) do
			puts 'binding(:image) do'

			src = ""
			name = ""
			unless bindable.nil?
				unless bindable.name.nil?
					name = bindable.name

					unless bindable.image_url.nil? || bindable.image_url.length == 0
						pp 'bindable.image_url.nil? || bindable.image_url.length == 0'
						src = bindable.image_url
					else
						needle = bindable.name
						haystack = [
							'Abbie-Cataldo',
							'Adam-Whipple',
							'Alex-Moore',
							'Andrew-Hall',
							'Angie-Holt',
							'Ben-Jarrell',
							'Brad-Garland',
							'Candy-Ballenger',
							'Chris-Beaman',
							'Clay-Thomas',
							'Collier-Ward',
							'Dale-Gipson',
							'David-Cochran',
							'Doug-Martinson',
							'Drew-Chapman',
							'Elissa-Cain',
							'Eric-Gregorian',
							'Eric-John',
							'Everett-Brooks',
							'George-Kobler',
							'George-Smith',
							'Hall-Bryant',
							'Jacob-Birmingham',
							'Jeff-Hammock',
							'Jeff-Irons',
							'Jeremiah-Arsenault',
							'Joe-MacKen	zie',
							'Krista-Campbell',
							'Kyle-Newman',
							'Laurie-Heard',
							'Marty-Sellers',
							'Matt-Massaro',
							'Mital-Modi',
							'Paul-Finley',
							'Rich-Marsden',
							'Rob-Campbell',
							'Robb-Dempsey',
							'Samantha-Brinkley',
							'Scott-Cribbs',
							'Seth-Turner',
							'Stephen-Hall',
							'Tarra-Anzalone',
							'Vicki-Morris'
						]
						if haystack.include?(needle)
							pp 'haystack includes needle'
							src = "https://s3.amazonaws.com/openhsv.com/manual-uploads/" + name + ".jpg"
						else
							src = "/img/profile-backup.png"
						end
						pp 'ELSE bindable.image_url.nil? || bindable.image_url.length == 0'
					end
				else
					pp 'ELSE bindable.name.nil?'
				end
			else
				pp 'bindable NIL'
			end
			pp src
			{
				:src => src,
				:title =>  name,
				:alt => name
			}
		end

		# binding(:image_unveil) do
		# 	src = ""
		# 	name = ""
		# 	unless bindable.nil?
		# 		unless bindable.first_name.nil? || bindable.last_name.nil?
		# 			name = bindable.first_name + " " + bindable.last_name
    #
		# 			unless bindable.image_url.nil?
		# 				src = bindable.image_url
		# 			else
		# 				src = "https://s3.amazonaws.com/openhsv.com/manual-uploads/" + bindable.first_name + "-" + bindable.last_name + ".jpg"
		# 			end
		# 		end
		# 	end
		# 	{
    #
		# 		:'data-src' => src,
		# 		:title =>  name,
		# 		:alt => name
		# 	}
		# end
		#binding(:custom_url) do
		#	bindable.custom_url
		#end
		# binding(:admin) do
		# 	{
		# 		:checked => bindable[:admin]
		# 	}
		# end
    #
		# binding(:approved) do
		# 	{
		# 		:checked => bindable[:approved]
		# 	}
		# end

		binding(:group_link) do
			name = ""
		 	unless bindable.name.nil?
		 		name = bindable.name
		 	end
		 	{
		 	:href => "/groups/" + bindable.id.to_s,
			:content => name
			}
		end

		binding(:edit_group_link) do
				{
		 		:href => "/groups/" + bindable.id.to_s + "/edit"
		 		}
		end

		binding(:admin_fieldset) do
      		visible = "hide"

			# 1. Check to make sure that the route is only shown for editting the group (not creating a new group)
			# new: /events/new
			# edit: /events/:events_id/edit
			isEditPage = false
			splat = request.path.split("/")
			unless splat[1].nil? || splat[1].length == 0
				if splat[1] == "groups"
					unless splat[2].nil? || splat[2].length == 0
						if splat[2] != "new"
							isEditPage = if splat[3].nil? == false && splat[3].length > 0 && splat[3] == "edit" then true else false end
						end
					end
				end
			end

			if isEditPage
				# 2. We are editting, but check if we're site admin and/or group admin to expose admin_fieldset
				people = People[cookies[:people]]
						isSiteAdmin = people != nil && people.admin != nil && people.admin == true

						group = Group[bindable.id]
						isGroupAdmin = logged_in_user_is_manager_of_group(group)

						if isGroupAdmin || isSiteAdmin
							visible = "show"
						end
					end
			{
				:class => visible
			}
		end

		binding(:container) do
			classes = "profile"
			unless bindable.categories.nil?
				jsn = bindable.categories.to_s
				array = JSON.parse(jsn)
				unless array[0].nil? || array[0].length == 0
					classes = classes + " " + get_css_classes_for_category(array[0])
				end

				unless array[1].nil? || array[1].length == 0
					classes = classes + " " + get_css_classes_for_category(array[1])
				end

				unless array[2].nil? || array[2].length == 0
					classes = classes + " " + get_css_classes_for_category(array[2])
				end
			end
			{
				:class => classes
			}
		end

		binding(:description) do
			bindable.description
		end

		binding(:delete_group_link) do
			cssclass = "delete-btn"
			people = People[cookies[:people]]
			isSiteAdmin = people != nil && people.admin != nil && people.admin == true
			
			if bindable.approved && isSiteAdmin == false
				cssclass = "hide"
			else
				splat = request.path.split("/")
				# Either /events/new, or /events/:events_id/edit
				unless splat[1].nil? || splat[1].length == 0
					if splat[1] == "groups"
						unless splat[2].nil? || splat[2].length == 0
							if splat[2] == "new"
								cssclass = "hide"
							end
						end
					end
				end
			end
			{
			:content => "Delete",
			:href => '/groups/' + bindable.id.to_s + '/delete',
			:class => cssclass
			}
		end

		binding(:group_edit_link) do
			cssclass = "btn pull-right"
			group = Group[bindable.id]
			if logged_in_user_is_manager_of_group(group) == false
				cssclass = "hide"
			end
			{
				:content => "Edit Group",
				:class => cssclass,
				:href => "/groups/" + bindable.id.to_s + "/edit"
			}
		end

		binding(:websiteadmin_fieldset) do
      		visible = "hide"
			people = People[cookies[:people]]
			isSiteAdmin = people != nil && people.admin != nil && people.admin == true
			if isSiteAdmin
				visible = "show"
			end
			{
			:class => visible
			}
		end

		binding(:flyer_category) do
			{
			:content => bindable.flyer_category
			}
		end

		binding(:flyer_fa_icon) do
			{
			:content => bindable.flyer_fa_icon
			}
		end
  end
end

Pakyow::App.bindings :group_admins do
	scope :group_admins do
		restful :group_admins

		binding(:admin_name) do
			{
			:content => bindable.first_name + " " + bindable.last_name
			}
		end

		binding(:remove_admin) do
			group_id = ""
			content = "[x]"
			cssclass = ""
			splat = request.path.split("/")
			unless splat[1].nil? || splat[1].length == 0
				if splat[1] == "groups"
					unless splat[2].nil? || splat[2].length == 0
						unless splat[2] == "new"
							group_id = splat[2]
						end
					end
				end
			end
			href = "#"
			#Note: we are not allowing a user to remove themselves as admin
      people = People[cookies[:people]]
      unless people.nil?
				if people.id == bindable.id || bindable.admin == true
					content = ""
					cssclass = "hide"
				elsif group_id.length == 0
					href = "/"
				else
					href = "/groups/" + group_id + "/removeadmin/" + bindable.id.to_s
				end
			end
			{
				:class => cssclass,
				:content => content,
				:href => href
			}
		end
	end
end
