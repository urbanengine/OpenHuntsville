class Group < Sequel::Model(:groups)
  plugin :validation_helpers

  many_to_many :people, :left_key=>:group_id, :right_key=>:people_id, :join_table=>:group_admins

  def validate
    # validates_presence :name
  end

end
