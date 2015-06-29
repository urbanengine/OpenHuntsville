Pakyow::App.bindings :catego do
  require "pp"
  scope :head do

    binding(:category) do
      
      {
        :content => bindable.category
      }
    end # colorbox
    binding(:parent) do
      {
        :content => "asdf"
      }
    end
  end
end