Pakyow::App.bindings :categories do
  require "pp"
  scope :categories do
    restful :categories
    binding(:category) do
      {
        :content => bindable.category,
        :id => "category" + bindable.id.to_s,
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
      {
        :content => bindable.description
      }
    end

  end

end