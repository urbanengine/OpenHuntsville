Sequel.migration do
  up do
    alter_table(:events){add_foreign_key :created_by, :people}
    alter_table(:events){add_foreign_key :updated_by, :people}
  end

  down do
  end
end