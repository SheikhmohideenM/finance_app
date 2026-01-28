class Api::V1::PotsController < ApplicationController
  # protect_from_forgery with: :null_session

  before_action :authenticate_user!

  before_action :set_pot, only: [ :show, :update, :destroy, :add_money, :withdraw ]


  def index
    pots = current_user.pots.order(created_at: :desc)
    render json: pots.map { |p| serialize(p) }
  end

  def show
    render json: serialize(@pot)
  end

  def create
    pot = current_user.pots.new(pot_params)

    if pot.save
      render json: serialize(pot), status: :created
    else
      render json: { errors: pot.errors.full_message }, status: :unprocessable_entity
    end
  end

  def update
    if @pot.update(pot_params)
      render json: serialize(@pot)
    else
      render json: { errors: @pot.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @pot.destroy
    render json: { message: "Pot deleted successfully" }
  end

  def add_money
    amount = params.require(:amount).require(:amount).to_f

    if amount <= 0
      return render json: { errors: [ "Amount must be greater than zero" ] }, status: :unprocessable_entity
    end

    @pot.update!(saved: @pot.saved + amount)
    render json: serialize(@pot)
  end

  def withdraw
    amount = params.require(:amount).require(:amount).to_f

    if amount <= 0 || amount > @pot.saved
      return render json: { errors: [ "Invalid withdrawal amount" ] }, status: :unprocessable_entity
    end

    @pot.update!(saved: @pot.saved - amount)
    render json: serialize(@pot)
  end

  private

  def set_pot
    @pot = current_user.pots.find(params[:id])
  end

  def pot_params
    params.require(:pot).permit(:name, :target, :color)
  end

  def serialize(pot)
    {
      id: pot.id,
      title: pot.name.titleize,
      color: pot.color,
      saved: pot.saved.to_f,
      target: pot.target.to_f,
      percent: pot.percent
    }
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def authenticate_user!
    render json: { error: "Unauthorized" }, status: :unauthorized unless current_user
  end
end
