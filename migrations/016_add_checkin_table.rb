Sequel.migration do
  up do
    create_table :checkins do
      primary_key :id
      foreign_key :people_id, :people
      foreign_key :event_id, :events
      Time        :created_at
    end
  end

  down do
    drop_table :checkins
  end
end
