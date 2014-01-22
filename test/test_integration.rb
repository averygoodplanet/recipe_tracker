require_relative 'helper'

class TestIntegrationTests < MiniTest::Unit::TestCase
  def test1_command_line_arguments_stored
    command = `./recipe_tracker create 'My New Recipe`
    assert_equal "create", ARGV[0]
    assert_equal "'My New Recipe'", ARGV[1]
  end

  def test2_error_if_improper_number_of_command_line_arguments
    command = "./recipe_tracker one two three"
    assert_command_output "Incorrect number of arguments, type 'help' for help.",
    command
  end

####### Check to see if tests below need to be changed,
#### *see class example of options parser.
  def test_create_calls_its_method
  end

  def test_find_calls_its_method
  end

  def page_calls_its_method
  end

  def delete_calls_its_method
  end

  def query_calls_its_method
  end

  def help_calls_its_method
  end

  # def test_valid_purchase_information_gets_printed
  #   command = "./grocerytracker add Cheerios --calories 210 --price 1.50"
  #   expected = "Theoretically creating: a purchase named Cheerios, with 210 calories and $1.50 cost"
  #   assert_command_output expected, command
  # end
end