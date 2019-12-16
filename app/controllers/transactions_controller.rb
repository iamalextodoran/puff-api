class TransactionsController < ApplicationController
  # has_scope :by_type,

  def index
    render json: Transaction.all
  end

  def show
    trans = Transaction.find(params[:id])
    render json: trans
  end

  def create
    trans = Transaction.create!(transaction_params.merge(user_id: 42))
    render json: trans
  end

  def update
    trans = Transaction.find(params[:id])
    trans.update(transaction_params)
    render json: trans
  end

  def destroy
    trans = Transaction.find(params[:id])
    trans.destroy
    render json: trans
  end

  private

  def transaction_params
    api_parameters(:name, :description, :amount, :type_of_t, :category, :date)
  end
end
