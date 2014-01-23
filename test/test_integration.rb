require_relative 'helper'

class TestIntegrationTests < MiniTest::Unit::TestCase

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
    `./recipe_tracker create 'Ham Sandwich' -i 'ham, cheese, bread' -d 'put between bread' -t 20 -m 'entree' -s 5 -c 40`
    results = database.execute("select recipe_name, ingredients, directions, time, meal, serves, calories from recipes")
    expected = ["Ham Sandwich", 'ham, cheese, bread', 'put between bread', 20, 'entree', 5, 40]
    assert_equal expected, results[0]
  end

  # def test_valid_purchase_information_gets_printed
  #   command = "./grocerytracker add Cheerios --calories 210 --price 1.50"
  #   expected = "Theoretically creating: a purchase named Cheerios, with 210 calories and $1.50 cost"
  #   assert_command_output expected, command
  # end
end