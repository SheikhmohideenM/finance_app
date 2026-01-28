class UsersController < ApplicationController
    # skip_before_action :verify_authenticity_token

    skip_forgery_protection only: [ :create ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      render json: { success: true, user: @user }
    else
      render json: { success: false, errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end
end
