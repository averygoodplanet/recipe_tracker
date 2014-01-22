require_relative 'helper'

class TestEnteringPurchases < MiniTest::Unit::TestCase
  def test_valid_purchase_information_gets_printed
    command = "./grocerytracker add Cheerios --calories 210 --price 1.50"
    expected = "Theoretically creating: a purchase named Cheerios, with 210 calories and $1.50 cost"
    assert_command_output expected, command
  end
end