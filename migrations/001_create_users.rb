Sequel.migration do
  up do
    create_table :users do
      primary_key   :id
      String        :email
      String        :first_name
      String        :last_name
      String        :company
      String        :twitter
      String        :linkedin
      String        :url
      String        :other_info
      json          :categories
      String        :categories_string
      String        :crypted_password
      Time          :created_at
      Time          :updated_at
      String        :image_url
    end
  end

  down do
    drop_table :users
  end
end