class UserEvent < ApplicationRecord
  belongs_to :user

  enum :category, {
    sign_up: 0,
    log_in: 1,
  }
end
