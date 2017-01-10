Sequel.migration do
  up do
    create_table :venues do
      primary_key   :id
      DateTime      :created_at
      DateTime      :updated_at
      String        :name
      String        :description
    end
  end

  down do
    drop_table :venues
  end
end
