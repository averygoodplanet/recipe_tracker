#!/usr/bin/env ruby
# -*- ruby -*-

require_relative 'lib/environment'
require 'active_record'

require 'rake/testtask'
Rake::TestTask.new(test: "db:test:prepare") do |t|
  t.pattern = "test/test_*.rb"
end

desc "Run tests"
task :default => :test

desc 'import data from the given file'
task :import_data do #DONE###########################
  Environment.environment = "production"
  # require_relative 'lib/importer'
  # Importer.import("data/purchase_import.csv")
  require_relative 'models/recipe'
  Recipe.import("example_data2_one_row.csv")
end

db_namespace = namespace :db do
  desc "Migrate the db"
  task :migrate do
    Environment.environment = 'production'
    Environment.connect_to_database
    ActiveRecord::Migrator.migrate("db/migrate/")
    db_namespace["schema:dump"].invoke
  end
  namespace :test do
    desc "Prepare the test database"
    task :prepare do
      Environment.environment = 'test'
      Environment.connect_to_database
      file = ENV['SCHEMA'] || "db/schema.rb"
      if File.exists?(file)
        load(file)
      else
        abort %{#{file} doesn't exist yet. Run `rake db:migrate` to create it.}
      end
    end
  end
  desc 'Rolls the schema back to the previous version (specify steps w/ STEP=n).'
  task :rollback do
    Environment.environment = 'production'
    Environment.connect_to_database
    step = ENV['STEP'] ? ENV['STEP'].to_i : 1
    ActiveRecord::Migrator.rollback(ActiveRecord::Migrator.migrations_paths, step)
    db_namespace["schema:dump"].invoke
  end
  namespace :schema do
    desc 'Create a db/schema.rb file that can be portably used against any DB supported by AR'
    task :dump do
      require 'active_record/schema_dumper'
      Environment.environment = 'production'
      Environment.connect_to_database
      filename = ENV['SCHEMA'] || "db/schema.rb"
      File.open(filename, "w:utf-8") do |file|
        ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
      end
    end
  end
end