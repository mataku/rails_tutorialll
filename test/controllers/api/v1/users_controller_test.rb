require 'test_helper'

class Api::V1::UsersControllerTest < ActionController::TestCase

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @new_user = { name: "Example User",
                  email: "user@example.com",
                  password: "password",
                  password_confirmation: "password"}
  end

  test "GET api/v1/users" do
    get :index, format: 'json'
    assert_response 200
    users = User.paginate(page: 1).to_json
    assert_match users, response.body
  end

  test "GET api/v1/users/:id" do
    get :show, format: 'json', id: @user.id
    assert_response 200
    assert_match @user.to_json, response.body

    # 他のidのユーザーはいない
    assert_no_match @other_user, response.body
  end

  test "POST api/v1/users" do

    # ユーザーが登録ステップに異常はないか
    assert_difference 'User.count', 1 do
      post :create, format: 'json', user: @new_user
    end
    assert_response 200

    # 登録が正常に行われなかった場合の確認
    # 上と同データ (emailが衝突するはず)
    assert_no_difference 'User.count' do
      post :create, format: 'json', user: @new_user
    end
    assert_response :unprocessable_entity
  end

end
