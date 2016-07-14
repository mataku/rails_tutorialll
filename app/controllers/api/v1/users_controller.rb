class Api::V1::UsersController < ApplicationController

  # CSRFの認証用 (設定を後で考える)
  skip_before_action :verify_authenticity_token

  def index
    # ページごとにユーザーを表示する
    @users = User.paginate(page: params[:page])
    render json: @users
  end

  def show
    @user = User.find(params[:id])
    render json: @user
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      render json: @user, status: 200
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find_by(id: params[:id])

    if @user.nil?
      render json: {status: 404, content: {message: "No such user!"}}, status: 404 # :not_found
    elsif @user.update_attributes(user_params)
      render json: {status: 200, content: {message: "Updated!"}}, status: 200 # :ok
    else
      render nothing: true, status: 422 # :unprocessable_entity
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    if @user.nil?
      render json: {status: :unprocessable_entity, content: {message: "No such user!"}}, status: :unprocessable_entity
    else
      @user.destroy
      render json: {content: {message: "Deleted!"}}, status: 200
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
