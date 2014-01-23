require_relative 'helper'

class TestIntegrationTests < MiniTest::Unit::TestCase

  def test1_error_if_more_than_two_command_line_arguments
    command = "./recipe_tracker one two three"
    assert_command_output "Incorrect number of arguments (more than 2), type 'help' for help.",
    command
  end

  # def test_valid_purchase_information_gets_printed
  #   command = "./grocerytracker add Cheerios --calories 210 --price 1.50"
  #   expected = "Theoretically creating: a purchase named Cheerios, with 210 calories and $1.50 cost"
  #   assert_command_output expected, command
  # end
end