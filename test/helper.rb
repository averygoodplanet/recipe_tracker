require 'minitest/autorun'
require_relative '../lib/environment'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

class RecipeTest < MiniTest::Unit::TestCase

  def setup
    Environment.environment = "test"
    Environment.database_connection
  end

  def database
    database = Environment.database_connection
    # will swith to Environment.connect_to_database
  end

  def teardown
    database.execute("delete from recipes")
    # DatabaseCleaner.clean
    # or e.g. Recipe.destroy_all
  end

  def assert_command_output expected, command
    actual = `#{command}`.strip
    assert_equal expected, actual
  end
end