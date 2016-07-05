require 'test_helper'

class ShowUsersTest < ActionDispatch::IntegrationTest
  def setup
    @login_user = users(:michael)

    # test/fixtures/users.ymlにて
    # lanaさん: activated: true
    # archer(Sterling Archer)さんを activated: falseに指定してテストをしてみる

    @active_user = users(:lana)
    @non_active_user = users(:archer)
  end

  test "behavior of /users page" do

    get root_path
    log_in_as(@login_user)
    get users_path

    # Lana Kaneさんは activated:true なので表示されるはず
    assert_match /Lana\ Kane/i, response.body

    # Sterling Archerさんは activated:false なので表示されていないはず
    assert_no_match /Sterling\ Archer/i, response.body

    # users/:id (activated userは見れる)
    get user_path(@active_user)
    assert_response :success

    # users/:id (non activated userは見れずに、rootへ戻される)
    get user_path(@non_active_user)
    assert_redirected_to root_url

  end
end
