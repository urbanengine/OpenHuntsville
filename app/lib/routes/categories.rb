Pakyow::App.routes(:categories) do
  include SharedRoutes

  expand :restful, :categories, '/categories' do

    collection do
      get '/:parent/:categories_id' do
        parent = Category.where("slug = ?",params[:parent]).first
        category = Category.where(:slug => params[:categories_id], :parent_id => parent.id).first
        subset = Array.new
        all =  People.all
        all.each { |person|
          unless person.categories.nil?
            jsn = person.categories.to_s
            array = JSON.parse(jsn)    
            array.each { |cat|
              unless cat.nil? || category.nil?
                if cat == category.id.to_s
                  subset.push(person)
                end
              end
            }
          end
        }
        presenter.path = "categories/show"
        view.scope(:people).apply(subset)
        view.scope(:categories).apply(category)
      end
    end
    action :new do
            redirect "/"

    end

    action :create do
            redirect "/"
    end


    # GET /people; same as Index
    action :list, :before => :route_head do
      categories = Category.all
      view.scope(:categories).apply(categories)
    end

    # GET /people/:id
    action :show do
      pp params[:categories_id]
      category = Category.where("slug = ?",params[:categories_id]).first
      subset = Array.new
      all =  People.all
      all.each { |person|
        unless person.categories.nil?
          jsn = person.categories.to_s
          array = JSON.parse(jsn)    
          array.each { |cat|
            unless cat.nil? || cat.length == 0 || category.nil?
              if cat == category.id.to_s
                subset.push(person)
              else
                child = Category[cat]
                if child.parent_id.to_s == category.id.to_s
                  subset.push(person)
                end
              end
            end
          }
        end
      }
      view.scope(:people).apply(subset)
      view.scope(:categories).apply(category)
    end

    # GET /people/:id/edit
    action :edit do
            redirect "/"
    end

    action :update do
            redirect "/"
    end

    post :save, 'save' do
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
