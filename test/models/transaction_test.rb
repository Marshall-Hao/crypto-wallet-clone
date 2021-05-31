require 'test_helper'

class TransactionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "deposit returns the activity deposit and amount" do
    transaction = Transaction.new(activity: "deposit", amount: 100)
    assert_equal "deposit 100", transaction.deposit_money
  end

  test "withdraw returns the activity withdraw and amount" do
    transaction = Transaction.new(activity: "withdraw", amount: 100)
    assert_equal "withdraw 100", transaction.withdraw_money
  end
end
