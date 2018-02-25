Sequel.migration do
  up do
    add_column :people, :is_elite, "BOOLEAN", :default => false
  end
  down do
  end
end