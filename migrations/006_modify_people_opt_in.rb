Sequel.migration do
  up do
    add_column :people, :opt_in_time, Time
    add_column :people, :opt_in, "BOOLEAN", :default => false
  end
  down do
  end
end
