Sequel.migration do
  up do
		create_table :tokens do
			primary_key       :id
			foreign_key       :people_id, :people
			String            :type
			String            :code
			String	  	  		:callback_url
			TrueClass         :valid, :default => true
			DateTime          :expires_at
			DateTime          :used_at
			DateTime          :created_at
			DateTime          :updated_at
		end
	end

	down do
		drop_table :tokens
	end
end
