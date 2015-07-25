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
      else
        content = "Everyone"
      end
      {
        :content => content,
        :href => href,
        :class => css_class
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
      css_class = ""
      if bindable.is_a? Category
        content = bindable.category
        href = bindable.url
      else
        content = "Everyone"
      end
      {
        :content => content,
        :href => href,
        :class => css_class
      }
  end # :cat

  binding(:list_item) do
    css_class = ""
    if bindable.is_a? Category
      if request.path == bindable.url
        puts bindable.url
        puts request.path
        css_class = "selected"
      end
    elsif request.path == "/people"
      puts request.path
      css_class = "selected"
    end
    {
      :class => css_class
    }
  end

  end

end