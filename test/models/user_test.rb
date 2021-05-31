require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "email returns the register user email" do
    user = User.new(email: "123456@123.com", encrypted_password: "lennon", admin: true)
    assert_equal "123456@123.com", user.email
  end
end
