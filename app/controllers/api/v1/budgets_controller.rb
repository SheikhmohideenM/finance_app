class Api::V1::BudgetsController < ApplicationController
  protect_from_forgery with: :null_session

  before_action :set_budget, only: [ :show, :update, :destroy ]

  def index
    budgets = Budget.order(created_at: :desc)
    render json: budgets.map { |b| serialize(b) }
  end

  def show
    render json: serialize(@budget)
  end

  def create
    budget = Budget.new(budget_params)

    if budget.save
      render json: serialize(budget), status: :created
    else
      render json: { errors: budget.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @budget.update(budget_params)
      render json: serialize(@budget)
    else
      render json: { errors: @budget.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @budget.destroy
    render json: { message: "Budget deleted successfully" }
  end

  private

  def set_budget
    @budget = Budget.find(params[:id])
  end

  def budget_params
    params.require(:budget).permit(:category, :color, :max).tap do |p|
      p[:title] = p[:category]
    end
  end

  def serialize(budget)
    {
      id: budget.id,
      title: budget.title.titleize,
      category: budget.category,
      max: budget.max,
      color: budget.color,
      spent: budget.spent,
      remaining: budget.remaining
    }
  end
end
