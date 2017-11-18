Sequel.migration do
    up do
      add_column :people, :archived, "BOOLEAN", :default => false
    end
    down do
    end
  end
  