require 'minitest/autorun'
require_relative '../lib/environment'

class RecipeTest < MiniTest::Unit::TestCase

  def database
    database = SQLite3::Database.new("db/recipe_tracker_test.sqlite3")
  end

  def teardown
    database.execute("delete from recipes")
  end

  def assert_command_output expected, command
    actual = `#{command}`.strip
    assert_equal expected, actual
  end
end