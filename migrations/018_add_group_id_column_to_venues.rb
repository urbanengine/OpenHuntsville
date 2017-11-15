Sequel.migration do
    up do
        alter_table(:venues){ add_foreign_key :group_id, :groups}
    end
    down do
    end
  end