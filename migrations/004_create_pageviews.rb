Sequel.migration do
  up do
    create_table :pageviews do
      primary_key :id
      foreign_key :visitor, :people
      String      :page
      Time        :created_at
      Time        :updated_at
	  end
	end

  down do
    drop_table :pageviews
  end
end