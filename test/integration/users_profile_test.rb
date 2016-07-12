require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
    @following_count = @user.following.count.to_s
    @followers_count = @user.followers.count.to_s
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name

    # This checks for an img tag with class gravatar inside a top-level heading tag (h1).
    assert_select 'h1>img.gravatar'

    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination'
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end

  test "stats on home page" do
    # Homeページ
    log_in_as(@user)
    get root_path

    # following, followers の表示部分
    # フォロー数の表示がユーザーのものと一致しているか
    assert_select "#following", text: @following_count
    # フォロワー数の表示がユーザーのものと一致しているか
    assert_select "#followers", text: @followers_count
    
  end

  test "stats on users page" do
    # usersページ
    log_in_as(@user)
    get user_path(@user)

    # フォロー数の表示がユーザーのものと一致しているか
    assert_select "#following", text: @following_count
    # フォロワー数の表示がユーザーのものと一致しているか
    assert_select "#followers", text: @followers_count

  end
end
