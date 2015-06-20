Sequel.migration do
	up do
  		add_column :people, :bio, String
	end
	down do
	end
end