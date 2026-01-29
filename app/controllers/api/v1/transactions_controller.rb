class Api::V1::TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_transaction, only: %i[update destroy undo]

  def index
    transactions = current_user.transactions
      .includes(:budget)
      .order(date: :desc)

    render json: transactions.map { |t| serialize(t) }
  end

  def create
    transaction = current_user.transactions.new(transaction_params)

    ActiveRecord::Base.transaction do
      transaction.save!

      transaction.account.update!(
        balance: transaction.account.balance - transaction.amount
      )

      if transaction.budget
        transaction.budget.increment!(:spent, transaction.amount)
      end
    end

    render json: transaction, status: :created
  end


  def update
    return forbidden unless @transaction.editable?

    old_amount = @transaction.amount
    new_amount = transaction_params[:amount].to_f
    diff = new_amount - old_amount

    ActiveRecord::Base.transaction do
      @transaction.update!(transaction_params)
      @transaction.account.update!(
        balance: @transaction.account.balance + diff
      )
    end

    render json: serialize(@transaction)
  end

  def destroy
    return forbidden unless @transaction.editable?

    ActiveRecord::Base.transaction do
      @transaction.account.update!(
        balance: @transaction.account.balance - @transaction.amount
      )
      @transaction.destroy!
    end

    head :no_content
  end

  def undo
    return render json: { error: "Undo allowed only within 24 hours" },
                  status: :forbidden unless @transaction.editable?

    return render json: { error: "Already undone" },
                  status: :unprocessable_entity if @transaction.undone?

    ActiveRecord::Base.transaction do
      @transaction.account.update!(
        balance: @transaction.account.balance + @transaction.amount
      )

      if @transaction.budget
        @transaction.budget.decrement!(:spent, @transaction.amount)
      end

      @transaction.update!(undone: true)
    end

    render json: { message: "Transaction undone successfully" }
  end

  private

  def set_transaction
    @transaction = current_user.transactions.find(params[:id])
  end

  def forbidden
    render json: { errors: [ "Action allowed only within 24 hours" ] }, status: :forbidden
  end

  def transaction_params
    params.require(:transaction)
          .permit(:account_id, :budget_id, :amount, :date, :description)
  end

  def serialize(t)
    {
      id: t.id,
      amount: t.amount,
      date: t.date,
      description: t.description,
      created_at: t.created_at,
      budget_id: t.budget_id,
      category: t.budget&.category&.titleize,
      undone: t.undone
    }
  end
end
