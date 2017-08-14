Sequel.migration do
  up do
    add_column :groups, :archived, "BOOLEAN", :default => false
  end
  down do
  end
end
