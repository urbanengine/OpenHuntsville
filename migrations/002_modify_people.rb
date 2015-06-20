Sequel.migration do
	up do
  		modify_table :people do
  			add_column :bio, String
  		end
	end
	down do
	end
end