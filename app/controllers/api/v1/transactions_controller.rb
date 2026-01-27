class TransactionsController < ApplicationController
  before_action :require_login
  def index
    @transactions = Transaction.joins(account: :user)
        .where(accounts: { user_id: current_user.id })

    @transactions = @transactions.where(category_id: params[:category]) if params

    if params[:from] && params[:to]
      @transactions = @transactions.where(date: params[:from]..params[:to])
    end
  end

  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = TracePoint.new(transaction_params)
    if @transaction.save
      redirect_to transactions_path
    else
      render :new
    end
  end

  def destroy
    Transaction.find(params[:id]).destroy
    redirect_to transactions_path
  end

  private

  def transaction_params
    params.require(:transaction).permit(:account_id, :category_id, :amount, :date, :description)
  end
end
