class Expense < ApplicationRecord
  MUST_BELONG_TO_SELECTED_GROUP_ERROR = "must belong to the selected group".freeze

  belongs_to :user
  belongs_to :group

  validate :user_must_be_group_member

  def user_must_be_group_member
    unless user.groups.include?(group)
      errors.add(:user, MUST_BELONG_TO_SELECTED_GROUP_ERROR)
    end
  end
end
