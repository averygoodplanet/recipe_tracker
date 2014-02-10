# Run this unit test file by typing "ruby test/this_file_name.rb"

require_relative 'helper'

class TestUnitTest < RecipeTest
  def teardown_unit_test
    database = Environment.connect_to_database
    # database = Environment.database_connection
    # will swith to Environment.connect_to_database
    # database.execute("delete from recipes")
    Recipe.destroy_all
    # DatabaseCleaner.clean
    # or e.g. Recipe.destroy_all
  end

  def test_1u_retrieve_returns_hash_of_correct_recipe
    options1 = {:recipe_name => "Chicago Hot Dog", :ingredients=>'bun, dog, pickle, relish, tomato', :directions=>'assemble ingredients', :time=>'2', :meal=>'entree', :serves=>'1', :calories=>'300'}
    Recipe.create(options1)
    options2 =  {:recipe_name => "Cold Stew", :ingredients=>'water, vegetables', :directions=>'boil ingredients together then cool', :time=>'10', :meal=>'entree', :serves=>'5', :calories=>'400'}
    Recipe.create(options2)
    result = Recipe.retrieve("Chicago Hot Dog")
    # result_hash = result.attributes
    # result_hash.delete("id")
    # result_values = result_hash.values
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
    Recipe.import("example_data3_simplerows.csv")
    result = Recipe.find_by(recipe_name: "Tacos")
    expected = ["Tacos", "beef, cheese, lettuce, sour cream, hot sauce", "cook the ground beef, assemble ingredients", 20, "entree", 4, 500]
    result_hash = result.attributes
    result_hash.delete("id")
    result_array = result_hash.values
    assert_equal expected, result_array
    teardown_unit_test
  end

  def test_4u_recipes_under_calories_returns_recipe_names
    Recipe.import("example_data3_simplerows.csv")
    result = Recipe.recipes_under_calories(600)
    expected = ["Cabbage Comfort", "Tacos"]
    assert_equal expected, result
    teardown_unit_test
  end

  def test_5u_all_recipes_returns_all_recipe_names
    Recipe.import("example_data4_simplerows.csv")
    result = Recipe.all_recipe_names
    expected = ["Tacos", "Cabbage Comfort", "Pizza"]
    assert_equal expected.to_set, result.to_set
    teardown_unit_test
  end

  def test_6u_all_recipes_returns_all_recipe_names_alphabetical_order
    Recipe.import("example_data4_simplerows.csv")
    result = Recipe.all_recipe_names
    expected = ["Cabbage Comfort", "Pizza", "Tacos"]
    assert_equal expected, result
    teardown_unit_test
  end
end