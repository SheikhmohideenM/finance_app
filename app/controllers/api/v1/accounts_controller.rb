class AccountsController < ApplicationController
  # before_action :require_login
  def index
    render json: current_user.accounts
  end

  def new
    @accounts = current_user.accounts.new
  end

  def create
    @accounts = current_user.accounts.new(account_params)
    if @accounts.save
      redirect_to accounts_path
    else
      render :new
    end
  end

  def destroy
    current_user.accounts.find(params[:id].destroy)
    redirect_to accounts_path
  end

  private

  def account_params
    params.require(:account).permit(:name, :balance)
  end
end
