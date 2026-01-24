class CategoriesController < ApplicationController
  before_action :require_login
  def index
    @categories = current_user.categories
  end

  def new
    @categories = current_user.categories.new
  end

  def create
    @categories = current_user.categories.new(category_params)
    if @category.save
      redirect_to categories_path
    else
      render :new
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, :monthly_budget)
  end
end
