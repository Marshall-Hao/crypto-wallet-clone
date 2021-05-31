require "application_system_test_case"

class WalletsTest < ApplicationSystemTestCase

  test "lets a signed in user create a deposit transaction" do
    login_as users(:george)

    visit "/wallets/1/transactions/new?r"

    select "deposit", from: 'transaction_activity'
    fill_in "transaction_amount", with: 120
    # save_and_open_screenshot

    click_on 'Create Transaction'
    save_and_open_screenshot

    # Should be redirected to the wallet page with new product
    assert_selector "li", text: "deposit"
  end

   test "lets a signed in user create a transfer transaction" do
    login_as users(:george)

    visit "/wallets/1/transactions/new"

    select "transfer", from: 'transaction_activity'
    fill_in "transaction_amount", with: 80
    select "tom@abitbol.com", from: 'transaction_receiver_email'
    # save_and_open_screenshot

    click_on 'Create Transaction'
    save_and_open_screenshot

    # Should be redirected to the wallet page with new product
    assert_selector "li", text: "transfer"
  end
end
