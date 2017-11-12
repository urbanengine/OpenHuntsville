Sequel.migration do
    up do
      add_column :venues, :deprecated, "BOOLEAN", :default => false
    end
    down do
    end
  end