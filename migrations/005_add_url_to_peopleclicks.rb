Sequel.migration do
  up do
    add_column :people, :approved_on, Time
    add_column :people, :spam, "BOOLEAN"
    add_column :peopleclicks, :url, String
  end

  down do
  end
end