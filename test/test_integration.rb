require_relative 'helper'
require 'sqlite3'

class TestIntegrationTests < RecipeTest

  def test1_parse_create_command_and_puts_options
    command = "./recipe_tracker create 'Ham Sandwich' -i 'ham, cheese, bread' -d 'put between bread' -t 20 -m 'entree' -s 5 -c 40 --test_output"
    expected = "Theoretically did: create recipe Ham Sandwich; with ingredients ham, cheese, bread; with directions put between bread; time 20; meal entree; serves 5; calories 40."
    assert_command_output expected, command
  end

  def test2_require_recipe_name_on_create
    command = "./recipe_tracker create"
    expected = "Please enter a recipe name."
    assert_command_output expected, command
  end

  def test3_require_missing_fields_on_create
    command = "./recipe_tracker create 'Ham Sandwich' -i 'ham, cheese, bread' -d 'put between bread' -t 20 -m 'entree'"
    expected = "You must provide the number served and calories of the recipe you are creating."
    assert_command_output expected, command
  end

  def test4_save_a_recipe
    `./recipe_tracker create 'Ham Sandwich' -i 'ham, cheese, bread' -d 'put between bread' -t 20 -m 'entree' -s 5 -c 40 -o`
    results = database.execute("select * from recipes")
    expected = ["Ham Sandwich", 'ham, cheese, bread', 'put between bread', 20, 'entree', 5, 40]
    assert_equal expected, results[0]
  end

  def test5_save_a_recipe_with_test_database_teardown
    `./recipe_tracker create 'New Ham Sandwich' -i 'ham, cheese, bread' -d 'put between bread' -t 20 -m 'entree' -s 5 -c 40 -o`
    results = database.execute("select * from recipes")
    expected = ["New Ham Sandwich", 'ham, cheese, bread', 'put between bread', 20, 'entree', 5, 40]
    assert_equal expected, results[0]

    result = database.execute("select count(recipe_name) from recipes")
    assert_equal 1, result[0][0]
  end

  def test6_update_a_recipe
    `./recipe_tracker create 'New Ham Sandwich' -i 'ham, cheese, bread' -d 'put between bread' -t 20 -m 'entree' -s 5 -c 40 -o`
    `./recipe_tracker edit "New Ham Sandwich" -n "Prosciutto Sandwich" -i "prosciutto, cheese, bread" -c 60 -o`
    results = database.execute("select * from recipes")
    expected = ["Prosciutto Sandwich", "prosciutto, cheese, bread", "put between bread", 20, 'entree', 5, 60]
    assert_equal expected, results[0]
  end

  def test7_delete_a_recipe
    `./recipe_tracker create 'New Ham Sandwich' -i 'ham, cheese, bread' -d 'put between bread' -t 20 -m 'entree' -s 5 -c 40 -o`
    results = database.execute("select * from recipes")
    expected = ["New Ham Sandwich", 'ham, cheese, bread', 'put between bread', 20, 'entree', 5, 40]
    assert_equal expected, results[0]

    `./recipe_tracker delete "New Ham Sandwich"`
    result = database.execute("select count(recipe_name) from recipes")
    assert_equal 0, result[0][0]
  end
end