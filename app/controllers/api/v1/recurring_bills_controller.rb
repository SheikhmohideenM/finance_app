class Api::V1::RecurringBillsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bill, only: %i[show update destroy]

  def index
    render json: current_user.recurring_bills.order(next_run_on: :asc)
  end

  def show
    render json: @bill
  end
  def create
    bill = current_user.recurring_bills.new(bill_params)

    if bill.save
      render json: bill, status: :created
    else
      render json: { errors: bill.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @bill.update(bill_params)
      render json: @bill
    else
      render json: { errors: @bill.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @bill.destroy
    head :no_content
  end

  private

  def set_bill
    @bill = current_user.recurring_bills.find(params[:id])
  end

  def bill_params
    params.require(:recurring_bill).permit(
      :name,
      :amount,
      :frequency,
      :next_run_on,
      :auto_pay,
      :account_id,
      :budget_id
    )
  end
end
