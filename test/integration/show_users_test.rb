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

  test "behavior of /users page" do

    get root_path
    log_in_as(@login_user)
    get users_path

    # Lana Kaneさんは activated:true なので表示されるはず
    assert_match /Lana Kane/, response.body

    # Sterling Archerさんは activated:false なので表示されないはず
    assert_no_match /Sterling Archer/, response.body

    get user_path(@active_user)
    assert_response :success

    get user_path(@non_active_user)
    assert_redirected_to root_url

  end
end
