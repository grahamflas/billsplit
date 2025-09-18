class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :source, polymorphic: true

  enum :category, {
    expense_added: 0,
    settlement_created: 1,
    invitation_created: 2,
  }
end
