require 'rubygems'
require 'bundler/setup'
require 'active_record'
require 'sqlite3'
require 'csv'

project_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob(project_root + "/../models/*.rb").each{ |f| require f}

require_relative 'database'
require 'logger'
require 'yaml'

class Environment
  attr_reader :environment

  def self.environment= environment
    ## @@ means class variable, @ means instance variable
    @@environment = environment
  end

  #connects to database (NOT ActiveRecord version)
  def self.database_connection
    Database.connection(@@environment)
  end

  #connects to database using ActiveRecord
  def self.connect_to_database
    #converts YAML to a hash, with keys e.g. "test" or "production"
    connection_details = YAML::load(File.open('config/database.yml'))
    # establishes a connection to database using ActiveRecord
    ActiveRecord::Base.establish_connection(connection_details[@@environment])
  end

  def self.logger
    @@logger ||= Logger.new("logs/#{@@environment}.log")
  end
end