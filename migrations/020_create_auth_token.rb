Sequel.migration do
    up do
      create_table :auth_token do
        primary_key :id
        foreign_key :people_id, :people
        String      :token
        DateTime    :expiration_date
      end
    end
  
    down do
      drop_table :auth_token
    end
end