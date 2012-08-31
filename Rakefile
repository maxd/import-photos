require 'erb'
require 'sequel'

ROOT = File.expand_path('..', __FILE__)

config = YAML.load(ERB.new(File.read(File.join(ROOT, 'config/database.yml'))).result)
DATABASE = Sequel.connect(config)

namespace :db do

  desc 'Migrate the database'
  task :migrate do
    Sequel.extension :migration
    Sequel::Migrator.run(DATABASE, File.join(ROOT, 'db/migrations'))
  end

end