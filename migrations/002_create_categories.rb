Sequel.migration do
  up do
    create_table :categories do
      primary_key :id
      foreign_key :parent_id, :categories
      String      :category
      String      :description
      String      :url
      String      :slug
	  end
	end

  down do
  	drop_table :categories
  end
end