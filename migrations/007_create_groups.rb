Sequel.migration do
  up do
    create_table :groups do
      primary_key   :id
      DateTime      :created_at
      DateTime      :updated_at
      String        :name
      #String        :url
      String        :image_url
      String        :description
      #String        :email
      json          :categories
      String        :categories_string
      Boolean       :approved
      foreign_key :parent_id, :groups, :null=>true
    end

    # JOIN TABLE # PEOPLE
    create_table :group_admins do
      primary_key   :id
      DateTime      :created_at
      DateTime      :updated_at
      foreign_key   :group_id, :groups, :null=>false
      foreign_key   :people_id, :people, :null=>false
    end
  end

  down do
    drop_table :groups
    drop_table :group_admins
  end
end
