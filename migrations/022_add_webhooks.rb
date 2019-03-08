Sequel.migration do
    up do
      create_table :webhooks do
        primary_key :id
        String      :url
        DateTime    :created_at
      end
    end

    down do
      drop_table :webhooks
    end
end
