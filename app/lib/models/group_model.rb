class Group < Sequel::Model(:groups)
  plugin :validation_helpers

  many_to_many :people, :left_key=>:group_id, :right_key=>:people_id, :join_table=>:group_admins, :class=>"People"

  def validate
    # validates_presence :name
  end

  def category_one_id
    unless categories.nil?
      JSON.parse(categories.to_json)[0]
    end
  end

  def category_two_id
    unless categories.nil?
      JSON.parse(categories.to_json)[1]
    end
  end

  def category_three_id
    unless categories.nil?
      JSON.parse(categories.to_json)[2]
    end
  end
end
