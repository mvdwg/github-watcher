Sequel.migration do
  change do
    create_table(:alerts) do
      primary_key :id

      String :last_sha
      String :owner
      String :repo
      String :branch
      String :path
    end

    create_table(:alarms) do
      primary_key :id
      foreign_key :alert_id, :alerts
      String :first_sha
      String :second_sha

      String :status
    end
  end
end
