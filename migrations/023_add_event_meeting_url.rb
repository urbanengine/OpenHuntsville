Sequel.migration do
  up do
    add_column :events, :flyer_virtual_meeting_url, String
  end
  down do
  end
end
