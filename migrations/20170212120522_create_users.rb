Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id

      Integer :github_id
      String :github_login
    end

    alter_table(:alerts) do
      add_foreign_key :user_id, :users
    end
  end
end
