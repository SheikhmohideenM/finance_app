class Api::V1::TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_transaction, only: %i[show update destroy]

  # GET /api/v1/transactions
  def index
    transactions = current_user.transactions

    if params[:budget].present?
      transactions = transactions.where(budget_id: params[:budget])
    end

    if params[:from].present? && params[:to].present?
      transactions = transactions.where(date: params[:from]..params[:to])
    end

    render json: transactions.order(date: :desc)
  end

  def show
    render json: @transaction
  end

  def create
    transaction = current_user.transactions.new(transaction_params)

    ActiveRecord::Base.transaction do
      transaction.save!

      # Update account balance
      transaction.account.update!(
        balance: transaction.account.balance + transaction.amount
      )

      # Update budget spent
      if transaction.budget.present? && transaction.amount.negative?
        transaction.budget.update!(
          spent: transaction.budget.spent + transaction.amount.abs
        )
      end
    end

    render json: transaction, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def update
    old_amount = @transaction.amount
    new_amount = transaction_params[:amount].to_f

    diff = new_amount - old_amount

    old_spent = old_amount.negative? ? old_amount.abs : 0
    new_spent = new_amount.negative? ? new_amount.abs : 0
    spent_diff = new_spent - old_spent

    ActiveRecord::Base.transaction do
      @transaction.update!(transaction_params)

      @transaction.account.update!(
        balance: @transaction.account.balance + diff
      )

      if @transaction.budget.present?
        @transaction.budget.increment!(:spent, spent_diff)
      end
    end

    render json: @transaction
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end



  def destroy
    ActiveRecord::Base.transaction do
      @transaction.account.update!(
        balance: @transaction.account.balance - @transaction.amount
      )

      if @transaction.budget.present? && @transaction.amount.negative?
        @transaction.budget.decrement!(:spent, @transaction.amount.abs)
      end

      @transaction.destroy!
    end

    head :no_content
  end



  private

  def set_transaction
    @transaction = current_user.transactions.find(params[:id])
  end

  def transaction_params
  params.require(:transaction)
        .permit(:account_id, :budget_id,
                :amount, :date, :description)
  end
end
