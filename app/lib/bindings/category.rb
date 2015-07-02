Pakyow::App.bindings :categories do
  require "pp"
  scope :categories do
    restful :categories

    binding(:category) do
      {
        :content => bindable.category,
        :class => bindable.category
      }
    end # colorbox

    # binding(:parent) do
    #   ary = Array.new
    #   Category.all.each { |x| ary.push([x.id,x.category])}
    #   pp ary
    #   ary
    #   {
    #     :options => ary
    #   }
    # end
    options :abc do
      opts = [[]]

      Category.all.each do |x|
        opts << [x.id, x.category]
      end
pp opts
      opts
    end
  end
end