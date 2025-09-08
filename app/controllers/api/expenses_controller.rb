class Api::ExpensesController < Api::BaseController
  before_action :authenticate_user!
  before_action :get_expense_or_render_error
  before_action :authorize_user

  def update
    if expense.update(expense_params)
      render json: expense
    else
      render json: {
        errors: expense.errors.full_messages
      }, status: :unprocessable_content
    end
  end

  private

  def get_expense_or_render_error
    unless expense
      render json: { error: "error" }, status: :unprocessable_content
    end
  end

  def expense
    @expense ||= Expense.find_by(id: params[:id])
  end

  def authorize_user
    unless current_user.groups.include?(expense.group)
      head :unauthorized
    end
  end

  def expense_params
    params.
      require(:expense).
      permit(
        :amount,
        :reference,
        :user_id,
      )
  end
end
