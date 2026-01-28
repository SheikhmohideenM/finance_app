class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :create ]

  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      render json: { message: "Logged in successfully" }, status: :ok
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end

  def destroy
    reset_session
    render json: { success: true }
  end
end
