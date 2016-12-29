Pakyow::App.bindings :categories_menu do
  require "pp"
  scope :categories_menu do
  restful :categories_menu

    binding(:link) do
      content = ""
      href = "/people"
      css_class = ""
      if bindable.is_a? Category
        content = bindable.category
        href = bindable.url
        paths = bindable.url.split("/")
        data_cat = paths[2]
        url = request.path
        url = url.gsub(/\/$/, '')
        if url == bindable.url
          css_class = "selected-link active-link"
        else
          child_categories = Category.where("parent_id = ?",bindable.id).all
          child_categories.each {|item|
            if item.url == url
              css_class = "active-link"
            end
          }
        end
      else
        content = "Everyone"
      end
      {
        :content => content,
        :href => href,
        :class => css_class,
        :'data-cat' => data_cat
      }
  end # :cat

  binding(:list_item) do
    css_class = ""
    url = request.path
    url = url.gsub(/\/$/, '')
    if bindable.is_a? Category
      if url == bindable.url
        css_class = "selected active"
      else
        child_categories = Category.where("parent_id = ?",bindable.id).all
        child_categories.each {|item|
          if item.url == url
            css_class = "active"
          end
        }
      end
    elsif url == "/people"
      css_class = "selected"
    end
    {
      :class => css_class
    }
  end

  end
  scope :categories_submenu do
  restful :categories_submenu

    binding(:link) do
      content = ""
      href = "/people"
      data_cat = ""
      if bindable.is_a? Category
        content = bindable.category
        href = bindable.url
        unless bindable.parent_id.nil?
          paths = bindable.url.split("/")
          data_cat = paths[3]
        end
      else
        content = "Everyone"
      end
      {
        :content => content,
        :href => href,
        :'data-cat' => data_cat
      }
  end # :cat

  binding(:list_item) do
    css_class = ""
    if bindable.is_a? Category
      if request.path == bindable.url
        css_class = "selected"
      end
    elsif request.path == "/people"
      css_class = "selected"
    end
    {
      :class => css_class
    }
  end

  end

end
