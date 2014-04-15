Sequel.migration {

  up do
    create_table(:users) do
      primary_key :id
      String :email
      String :password
    end
  end

  down do
    drop_table(:users)
  end
}