Sequel.migration do
  up do
    add_column :events, :archived, "BOOLEAN", :default => false
  end
  down do
  end
end
