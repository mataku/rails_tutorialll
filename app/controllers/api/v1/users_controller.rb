class Api::V1::UsersController < ApplicationController

  # CSRFの認証用 (設定を後で考える)
  skip_before_action :verify_authenticity_token

  def index
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
      render nothing: true, status: 200
    else
      render json: @user.errors
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
