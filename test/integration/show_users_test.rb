require 'test_helper'

class ShowUsersTest < ActionDispatch::IntegrationTest
  def setup
    @login_user = users(:michael)

    # users.ymlにて
    # lanaさん: activated: true
    # archerさんを activated: falseに指定した

    @active_user = users(:lana)
    @non_active_user = users(:archer)
  end

  test "show users for activated user" do
    get root_path
    log_in_as(@login_user)
    get user_path(@active_user)
    assert_match /users\//, response.body
    assert_match /users\/\d/, response.body
  end

  test "show users for non activated user" do
    get root_path
    log_in_as(@login_user)
    get user_path(@non_active_user)
    p user_path(@non_active_user)
    assert_match /users\//, response.body
    assert_match /users\/\d/, response.body
  end
end
