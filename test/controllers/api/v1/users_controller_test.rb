require 'test_helper'

class Api::V1::UsersControllerTest < ActionController::TestCase

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @new_user_params = { name: "Example User",
                  email: "kjefbjekbfjeb@example.com",
                  password: "password",
                  password_confirmation: "password"}
  end

  # ユーザー全ての取得
  test "GET api/v1/users" do
    get :index, format: 'json'
    assert_response :ok
    users = User.all.to_json
    assert_match users, response.body
  end

  # 対応するIDのユーザーを取得
  test "GET api/v1/users/:id" do
    get :show, format: 'json', id: @user.id
    assert_response :ok
    assert_match @user.to_json, response.body

    # 他のidのユーザーはいないことの確認
    # TODO: もっといい感じにしたい
    assert_no_match @other_user.to_json, response.body
  end

  # ユーザー登録
  test "POST api/v1/users" do

    # ユーザーが登録ステップに異常はないか
    assert_difference 'User.count', 1 do
      post :create, format: 'json', user: @new_user
    end
    assert_response :ok

    # 登録が正常に行われなかった場合の確認
    # 上と同データ (emailが衝突するはず)
    assert_no_difference 'User.count' do
      post :create, format: 'json', user: @new_user
    end
    assert_response :unprocessable_entity
  end

  # profileの更新 (正常)
  test "update attributes" do
    patch :update, format: 'json', id: @other_user.id, user: @new_user_params
    assert_response :ok
  end

  # profileの更新 (エラー)
  test "should not update attributes when ID is unknown" do
    # 存在しないID
    patch :update, format: 'json', id: "abc", user: @new_user_params
    assert_response :not_found
  end

end
