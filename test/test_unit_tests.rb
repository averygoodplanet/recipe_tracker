# Run this unit test file by typing "ruby test/this_file_name.rb"

# name of the class file being tested
# require File.expand_path("./a_class_file.rb")
require 'minitest/autorun'
require 'sqlite3'
require 'csv'
require_relative 'helper'
require_relative '../models/recipe.rb'

class TestUnitTest < MiniTest::Unit::TestCase
  def teardown_unit_test
    database = SQLite3::Database.new("db/recipe_tracker_test.sqlite3")
    database.execute("delete from recipes")
  end

  def test_1u_retrieve_returns_hash_of_correct_recipe
    options1 = {:ingredients=>'bun, dog, pickle, relish, tomato', :directions=>'assemble ingredients', :time=>'2', :meal=>'entree', :serves=>'1', :calories=>'300', :test_output=>true}
    Recipe.create("Chicago Hot Dog", options1)
    options2 =  {:ingredients=>'water, vegetables', :directions=>'boil ingredients together then cool', :time=>'10', :meal=>'entree', :serves=>'5', :calories=>'400', :test_output=>true}
    Recipe.create("Cold Stew", options2)
    result =  Recipe.retrieve("Chicago Hot Dog", true)
    expected = ["Chicago Hot Dog", "bun, dog, pickle, relish, tomato", "assemble ingredients", 2, "entree", 1, 300]
    assert_equal expected, result
    teardown_unit_test
  end

  def test_2u_format_properly_formats_recipe
    unformatted_recipe = ["Turkey Hot Dog", "bun, dog, pickle, relish, tomato", "assemble ingredients", 2, "entree", 1, 300]
    result = Recipe.format(unformatted_recipe)
    expected = [ "*****",
                        "Recipe: Turkey Hot Dog",
                        "\n",
                        "Ingredients:", "\n",
                        "bun\ndog\npickle\nrelish\ntomato",
                        "\n",
                        "Directions:",
                        "\n",
                        "assemble ingredients",
                        "\n",
                        "Time: 2",
                        "Meal: entree",
                        "Serves: 1",
                        "Calories: 300",
                        "***end of recipe***",
                        "\n"]
    assert_equal expected, result
    teardown_unit_test
  end

  def test_3_CSV_spike
    Recipe.import("example_data.csv")
  end
end