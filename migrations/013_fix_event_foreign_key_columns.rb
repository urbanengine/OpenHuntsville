Sequel.migration do
  up do
    alter_table(:events){drop_foreign_key :created_by}
    alter_table(:events){drop_foreign_key :updated_by}
    alter_table(:events){add_foreign_key :created_by, :people, :default=>333}
    alter_table(:events){add_foreign_key :updated_by, :people, :default=>288}
  end

  down do
  end
end


