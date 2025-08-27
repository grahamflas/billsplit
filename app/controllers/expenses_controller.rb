class ExpensesController < ApplicationController
  before_action :authenticate_user!
  def show
  end

  def new
    @expense = Expense.new
  end

  def create
    @expense = Expense.new(expense_params)

    if @expense.save
      flash[:success] = "Added expense: #{@expense.reference}"

      redirect_to @expense.group
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def expense_params
    params.
      require(:expense).
      permit(
        :reference,
        :amount,
        :user_id,
        :group_id,
      )
  end
end
