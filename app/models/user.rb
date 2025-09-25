class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :validatable

  has_many :memberships
  has_many :groups, through: :memberships

  has_many :expenses

  has_many :created_invitations, class_name: "Invitation", foreign_key: :creator_id
  has_many :received_invitations, class_name: "Invitation", foreign_key: :invitee_id

  has_many :notifications

  def full_name
    "#{first_name} #{last_name}"
  end

  def email_prefix
    email.split("@").first
  end

  def email_domain
    email.split("@").second
  end
end
