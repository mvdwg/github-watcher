Sequel.migration do
  change do
    add_column :users, :email, String
  end
end
