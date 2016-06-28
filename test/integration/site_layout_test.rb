require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
  end

  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
  end

  # ログインユーザーにおける、ページレイアウトテスト
  test "layout links for logged-in users" do
    log_in_as(@user)
    get root_path
    # ログインしているので、"Log in"ページはない
    assert_select "a[href=?]", login_path, count: 0
    
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user)
  end

  # ログインしていないユーザーにおける、ページレイアウトテスト
  test "layout links for non-logged-in users" do
    get root_path
    assert_select "a[href=?]", login_path

    # ログインしていないので、ログインユーザー用のページはない
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", users_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
    assert_select "a[href=?]", edit_user_path(@user), count: 0
  end
end
