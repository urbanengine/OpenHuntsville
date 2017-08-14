Sequel.migration do
  up do
    add_column :events, :summary, String
  end

  down do
  end
end