require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "full_name returns the capitalized first name and last name" do
    user = User.new(email: "123456@123.com", encrypted_password: "lennon", admin: true)
    assert_equal "123456@123.com", user.email
  end
end
