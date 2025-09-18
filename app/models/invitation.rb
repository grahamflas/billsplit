class Invitation < ApplicationRecord
  belongs_to :group
  belongs_to :creator, class_name: "User"
  belongs_to :invitee, class_name: "User", optional: true

  has_many :notifications, as: :source

  enum :status, {
    pending: 0,
    accepted: 1,
    declined: 2
  }

  def accept
    if invitee
      update(status: :accepted)
      group.users << invitee
    end
  end

  def decline
    if invitee
      update(status: :declined)
    end
  end
end
