# Run this unit test file by typing "ruby test/this_file_name.rb"

require_relative 'helper'

class TestUnitTest < RecipeTest
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

  def test_3u_import_takes_data_from_CSV_and_saves_to_database
    Recipe.import("example_data3_simplerows.csv", true)
    result = Recipe.retrieve("Tacos", true)
    expected = ["Tacos", "beef, cheese, lettuce, sour cream, hot sauce", "cook the ground beef, assemble ingredients", 20, "entree", 4, 500]
    assert_equal expected, result
    teardown_unit_test
  end

  def test_4u_recipes_under_calories_returns_recipe_names
    Recipe.import("example_data3_simplerows.csv", true)
    result = Recipe.recipes_under_calories(600, true)
    expected = ["Cabbage Comfort", "Tacos"]
    assert_equal expected, result
    teardown_unit_test
  end

  def test_5u_all_recipes_returns_all_recipe_names
    Recipe.import("example_data4_simplerows.csv", true)
    result = Recipe.all_recipe_names(true)
    expected = ["Tacos", "Cabbage Comfort", "Pizza"]
    assert_equal expected.to_set, result.to_set
    teardown_unit_test
  end

  def test_6u_all_recipes_returns_all_recipe_names_alphabetical_order
    Recipe.import("example_data4_simplerows.csv", true)
    result = Recipe.all_recipe_names(true)
    expected = ["Cabbage Comfort", "Pizza", "Tacos"]
    assert_equal expected, result
    teardown_unit_test
  end
end