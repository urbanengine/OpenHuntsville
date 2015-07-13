Pakyow::App.routes(:categories) do
  include SharedRoutes

  expand :restful, :categories, '/categories' do

    action :new do
      pp "new"
            redirect "/"

    end

    action :create do
      pp "create"
            redirect "/"
    end


    # GET /people; same as Index
    action :list, :before => :route_head do
      pp "list"
      categories = Category.all
      view.scope(:categories).apply(categories)
      # categories.each_with_index { |x,i| view.scope(:categories)[i].bind({:abc=>x})}
      # view.scope(:categories).bind({ :type => :two})
    end

    # GET /people/:id
    action :show do
      pp "show"
            redirect "/"
    end

    # GET /people/:id/edit
    action :edit do
      pp "edit"
            redirect "/"
    end

    action :update do
      pp "update"
            redirect "/"
    end

    post :save, 'save' do
      pp params
      params.each do |key,value|
        unless key.include? "parent"
          category = nil
          unless key.include? "new"
            category = Category[key]
          else
            category = Category.new
          end
          unless category.nil?
            category.category = value
            unless params[key+"-parent"].nil?
              unless params[key+"-parent"].include? "none"
                category.parent_id = params[key+"-parent"]
              end
            end
            category.save
          end
        end
      end

      redirect "/categories"
    end
  end
end
