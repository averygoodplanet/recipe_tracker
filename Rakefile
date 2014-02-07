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

db_namespace = namespace :db do
  desc "Migrate the db"
  task :migrate do
    Environment.environment = 'production'
    Environment.database_connection
    # Environment.connect_to_database
    ActiveRecord::Migrator.migrate("db/migrate/")
    db_namespace["schema:dump"].invoke
  end
  namespace :test do
    desc "Prepare the test database"
    task :prepare do
      Environment.environment = 'test'
      Environment.database_connection
      # Environment.connect_to_database
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
    Environment.database_connection
    # Environment.connect_to_database
    step = ENV['STEP'] ? ENV['STEP'].to_i : 1
    ActiveRecord::Migrator.rollback(ActiveRecord::Migrator.migrations_paths, step)
    db_namespace["schema:dump"].invoke
  end
  namespace :schema do
    desc 'Create a db/schema.rb file that can be portably used against any DB supported by AR'
    task :dump do
      require 'active_record/schema_dumper'
      Environment.environment = 'production'
      Environment.database_connection
      # Environment.connect_to_database
      filename = ENV['SCHEMA'] || "db/schema.rb"
      File.open(filename, "w:utf-8") do |file|
        ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
      end
    end
  end
end






# # run rake make_production_database as a one-time thing
# task :make_production_database do
#   make_database("production")
# end

# # run rake make_test_database as a one-time thing
# task :make_test_database do
#   make_database("test")
# end

# def make_database(name)
#   require 'sqlite3'
#   # create the database file
#   database = SQLite3::Database.new("db/recipe_tracker_#{name}.sqlite3")
#   # create the empty recipes table within the database file
#   database.execute("CREATE TABLE recipes (id INTEGER PRIMARY KEY AUTOINCREMENT, recipe_name varchar(20), ingredients text, directions text, time integer, meal varchar(10), serves integer, calories integer)")
# end