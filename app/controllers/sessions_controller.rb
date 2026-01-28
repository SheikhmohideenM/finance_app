class SessionsController < ApplicationController
  # skip_before_action :verify_authenticity_token

  skip_forgery_protection only: [ :create ]

  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      render json: { success: true, user: user }
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end

  def destroy
    reset_session
    render json: { success: true }
  end
end
