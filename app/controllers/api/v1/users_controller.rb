class Api::V1::UsersController < ApplicationController

  # CSRF回避 (設定を後で考える)
  skip_before_action :verify_authenticity_token

  def index
    # ユーザー全ての取得
    @users = User.all
    render json: @users
  end

  def show
    # 対応するIDのユーザーを取得
    @user = User.find(params[:id])
    render json: @user
  end

  def create
    # ユーザー登録
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      render json: @user, status: 200
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    # ユーザー情報の更新
    @user = User.find_by(id: params[:id])

    if @user.nil?
      render json: {status: 404, content: {message: "No such user!"}}, status: 404 # :not_found
    elsif @user.update_attributes(user_params)
      render nothing: true, status: 200 # :ok
    else
      render nothing: true, status: 422 # :unprocessable_entity
    end
  end

  def destroy
    # ユーザーの削除
    @user = User.find_by(id: params[:id])
    if @user.nil?
      render json: {status: 404, content: {message: "No such user!"}}, status: 404 # :not_found
    else
      @user.destroy
      render json: {content: {message: "Deleted!"}}, status: 200
    end
  end

  def following
    # 何を返すかを決める
    # @user = User.find(params[:id])
    # @users = @user.following
    # render json: @users
  end

  def followers
    # 何を返すかを決める
    # @user = User.find(params[:id])
    # @users = @user.followers
    # render json: @users
  end

  private

    # 入力の必須項目
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
