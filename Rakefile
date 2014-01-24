#!/usr/bin/env ruby
# -*- ruby -*-

require 'rake/testtask'
Rake::TestTask.new() do |t|
  t.pattern = "test/test_*.rb"
end

desc "Run tests"
task :default => :test

# run rake make_production_database as a one-time thing
task :make_production_database do
  make_database("production")
end

# run rake make_test_database as a one-time thing
task :make_test_database do
  make_database("test")
end

def make_database(name)
  require 'sqlite3'
  # create the database file
  database = SQLite3::Database.new("db/recipe_tracker_#{name}.sqlite3")
  # create the empty recipes table within the database file
  database.execute("CREATE TABLE recipes ( recipe_name varchar(20), ingredients text, directions text, time integer, meal varchar(10), serves integer, calories integer)")
end