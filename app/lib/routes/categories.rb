Pakyow::App.routes(:categories) do
  include SharedRoutes

  expand :restful, :categories, '/categories' do

    collection do
      get '/:parent/:categories_id' do
        parent = Category.where("slug = ?",params[:parent]).first
        category = Category.where(:slug => params[:categories_id], :parent_id => parent.id).first
        subset = Array.new
        all =  People.where("approved = true").all
        all.each { |person|
          unless person.categories.nil?
            jsn = person.categories.to_s
            array = JSON.parse(jsn)    
            array.each { |item|
              unless item.nil? || category.nil?
                if item == category.id.to_s
                  subset.push(person)
                end
              end
            }
          end
        }
        presenter.path = "categories/show"
        view.scope(:people).apply(subset)
        view.scope(:categories).apply(category)

        all_cats = Category.order(:slug).all
        parent_cats = []
        all_cats.each { |item|
          if item.parent_id.nil?
            parent_cats.push(item)
          end
        }
        parent_cats.unshift("everyone")
        view.scope(:categories_menu).apply(parent_cats)

        current_cat = Category.where("url = ?",request.path).first
        child_cats = Category.where("parent_id = ?",current_cat.parent_id).all
        view.scope(:categories_submenu).apply(child_cats)
        view.scope(:head).apply(request)
        view.scope(:main_menu).apply(request)
      end # '/:parent/:categories_id'

      get 'title_and_description_from_slug' do
        cat_title = ""
        cat_desc = ""
        category = Category.where("slug = ?",params[:slug]).first
        unless category.nil?
          unless category.category.nil?
            cat_title = category.category
          end
          unless category.description.nil?
            cat_desc = category.description
          end
        end
        send cat_title + "|" + cat_desc
      end # 'title_and_description_from_slug' do

    end # collection do
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
      category = Category.where("slug = ?",params[:categories_id]).first
      subset = Array.new
      
      if session[:random].nil?
        session[:random] = (rand(0...100)).to_s
      end
      people = People.where("approved = true").all
      ran = session[:random].to_i*100
      shuffled = people.shuffle(random: Random.new(ran))

      shuffled.each { |person|
        unless person.categories.nil?
          jsn = person.categories.to_s
          array = JSON.parse(jsn)    
          array.each { |cat|
            unless cat.nil? || cat.length == 0 || category.nil?
              if cat == category.id.to_s
                unless subset.include?(person)
                  subset.push(person)
                end
              else
                child = Category[cat]
                if child.parent_id.to_s == category.id.to_s
                  unless subset.include?(person)
                    subset.push(person)
                  end
                end
              end
            end
          }
        end
      }
      view.scope(:people).apply(subset)
      view.scope(:categories).apply(category)
      all_cats = Category.order(:slug).all
      parent_cats = []
      all_cats.each { |item|
        if item.parent_id.nil?
          parent_cats.push(item)
        end
      }
      parent_cats.unshift("everyone")
      view.scope(:categories_menu).apply(parent_cats)
      url = request.path
      url = url.gsub(/\/$/, '')
      current_cat = Category.where("url = ?",url).first
      child_cats = Category.where("parent_id = ?",current_cat.id).all
      view.scope(:categories_submenu).apply(child_cats)
      view.scope(:head).apply(request)
      view.scope(:main_menu).apply(request)
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
