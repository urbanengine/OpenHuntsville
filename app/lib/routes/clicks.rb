Pakyow::App.routes(:clicks) do
  include SharedRoutes

  expand :restful, :clicks, '/clicks' do

    collection do
      get '/people/:person/:link' do
        # visitor_id = nil
        # visitor = People[cookies[:people]]
        # unless visitor.nil?
        #   visitor_id = visitor.id
        # end
        
        link = params[:link]
        person = get_first_person_from_people_id(params[:person])
        unless person.nil? || link.nil?

          # if visitor.nil? || !visitor.admin
          #   click = Peopleclick.new()
          #   click.column = link
          #   click.visitor = visitor_id
          #   click.profile = person.id
          #   click.url = request.referer
          #   click.save
          # end

          redirect_url = nil
          case link
          when "twitter"
            # redirect person.url
            if person.twitter.include? "http"
              redirect_url = person.twitter
            else
              redirect_url = "http://www.twitter.com/" + person.twitter
            end
          when "linkedin"
            if person.linkedin.include? "http"
              redirect_url = person.linkedin
            else
              redirect_url = 'http://www.linkedin.com/in/' + person.linkedin
            end
          when "url"
            redirect_url = person.url
          else
            pp link
          end
          
          unless redirect_url.nil?
            redirect redirect_url
          end
        end
      end # '/clicks/people/:click'

      # get 'title_and_description_from_slug' do
      #   cat_title = ""
      #   cat_desc = ""
      #   category = Category.where("slug = ?",params[:slug]).first
      #   unless category.nil?
      #     unless category.category.nil?
      #       cat_title = category.category
      #     end
      #     unless category.description.nil?
      #       cat_desc = category.description
      #     end
      #   end
      #   send cat_title + "|" + cat_desc
      # end # 'title_and_description_from_slug' do

    end # collection do
  
  end
end
