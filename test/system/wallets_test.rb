require "application_system_test_case"

class WalletsTest < ApplicationSystemTestCase
  test "visiting the index" do
    visit root_url

    # save_and_open_screenshot
    assert_selector "h2", text: "Welcome to the Crypto Wallet Clone"
  end

   test "lets a signed in user create a new wallet" do
    login_as users(:george)
    visit "/wallets/new"
    # save_and_open_screenshot

    fill_in "wallet_name", with: "Le Wagon"
    # save_and_open_screenshot

    click_on 'Create Wallet'
    save_and_open_screenshot

    # Should be redirected to the wallet page with new product
    assert_selector "h4", text: "Wallet Name: Le Wagon"
  end
end
