Sequel.migration do
  change do
    create_table :imported_files do
      primary_key :id

      String :file, null: false
      String :sha256, null: false, size: 32
      DateTime :created_at
      DateTime :updated_at

      index [ :sha256 ], unique: true
    end
  end
end