Pakyow::App.bindings :categories do
  require "pp"
  scope :categories do
    restful :categories
    binding(:category) do
      {
        :content => bindable.category,
        # :id => "category" + bindable.id.to_s,
        :name => "category" + bindable.id.to_s
      }
    end # colorbox

    binding(:category_label) do
      {
        :for => "category" + bindable.id.to_s
      }
    end


    binding(:category_id) do
      {
        :content => bindable.id,
        :id => "categoryId" + bindable.id.to_s,
        :name => "categoryId" + bindable.id.to_s
      }
    end

    binding(:category_id_label) do
      {
        :for => "categoryId" + bindable.id.to_s
      }
    end

    binding(:parent_category_id) do
      cat = Category[bindable.parent_id]
      {
        :content => bindable.parent_id.to_s,
        :id => "parentCategoryId" + bindable.parent_id.to_s,
        :name => "parentCategoryId" + bindable.parent_id.to_s
      }
    end

    binding(:parent_category_id_label) do
      {
        :for => "parentCategoryId" + bindable.parent_id.to_s
      }
    end

    binding(:parent_category) do
      catString = ""
      catIdString = ""
      unless bindable.parent_id.nil?
        cat = Category[bindable.parent_id]
        catString = cat.category
        catIdString = "parentCategory" + cat.id.to_s
      end
      {
        :content => catString,
        :id => catIdString,
        :name => catIdString
      }
    end

    binding(:parent_category_id_label) do
      {
        :for => "parentCategory" + bindable.parent_id.to_s
      }
    end

    binding(:description) do
      content = bindable.description
      if content.nil? || content.length < 1
        content = "This page features " + bindable.category + " freelancers, moonlighters, and consultants on #openHSV. Browse through them by scrolling below or use the industry filters to further refine your search."
      end
      {
        :content => content
      }
    end

    binding(:category_one_link) do
      href = ""
      content = ""
      title = ""
      if bindable.parent_id.nil?
        href = bindable.url
        content = bindable.category
        title = bindable.description
        if title.nil? || title.length < 1
          title = "This page features " + bindable.category + " freelancers, moonlighters, and consultants on #openHSV. Browse through them by scrolling below or use the industry filters to further refine your search."
        end
      else
        parent = Category[bindable.parent_id]
        href = parent.url
        content = parent.category
        title = parent.description
        if title.nil? || title.length < 1
          title = "This page features " + parent.category + " freelancers, moonlighters, and consultants on #openHSV. Browse through them by scrolling below or use the industry filters to further refine your search."
        end
      end
      {
        :href => href,
        :content => content,
        :title => title
      }
    end

    binding(:category_two_link) do
      pp bindable
      href = ""
      content = ""
      title = ""
      unless bindable.parent_id.nil?
        href = bindable.url
        content = bindable.category
        title = bindable.description
        if title.nil? || title.length < 1
          title = "This page features " + bindable.category + " freelancers, moonlighters, and consultants on #openHSV. Browse through them by scrolling below or use the industry filters to further refine your search."
        end
      end
      {
        :href => href,
        :content => content,
        :title => title
      }
    end

    binding(:category_spacer_two) do
      spacer = ""
      unless bindable.parent_id.nil?
        spacer = "&nbsp;/&nbsp;"
      end
      {
        :content => spacer
      }
    end

  end

end