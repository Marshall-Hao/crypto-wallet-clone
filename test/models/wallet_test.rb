require 'test_helper'

class WalletTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "wallet has balance returns the wallet's name and balance" do
    wallet = Wallet.new(name: "test", balance: 1000)
    assert_equal "test has 1000", wallet.wallet_balance
  end
end
