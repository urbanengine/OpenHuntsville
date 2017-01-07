Sequel.migration do
  up do
    create_table :peopleclicks do
      primary_key :id
      foreign_key :visitor, :people
      foreign_key :profile, :people
      String      :column
      Time        :created_at
      Time        :updated_at
	  end
	end

  down do
    drop_table :peopleclicks
  end
end