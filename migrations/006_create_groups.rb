Sequel.migration do
  up do
    create_table :groups do
      primary_key   :id
      DateTime      :created_at
      DateTime      :updated_at
      String        :name
      String        :image_url
      String        :description
      foreign_key :parent_id, :groups, :null=>true
    end

    # JOIN TABLE # PEOPLE
    create_table :group_admins do
      primary_key   :id
      foreign_key   :group_id, :groups, :null=>false
      foreign_key   :people_id, :people, :null=>false
      DateTime      :created_at
      DateTime      :updated_at
    end
  end

  down do
    drop_table :groups
    drop_table :group_admins
  end
end
