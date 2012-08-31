require 'sequel'

config = YAML.load_file(File.expand_path('../config/database.yml', __FILE__))
DATABASE = Sequel.connect(config)

namespace :db do

  desc 'Migrate the database'
  task :migrate do
    Sequel.extension :migration
    Sequel::Migrator.run(DATABASE, File.expand_path('../db/migrations', __FILE__))
  end

end