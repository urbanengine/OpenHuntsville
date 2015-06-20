Sequel.migration do
	alter_table(:people) do
  		add_column :bio, String
	end
end