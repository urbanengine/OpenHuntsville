Sequel.migration do
  up do
    add_column :groups, :flyer_category, String
    add_column :groups, :flyer_fa_icon, String
    add_column :events, :flyer_category, String
    add_column :events, :flyer_fa_icon, String
  end
  down do
  end
end
