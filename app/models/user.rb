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

  has_many :user_events

  def full_name
    "#{first_name} #{last_name}"
  end

  def email_prefix
    email.split("@").first
  end

  def email_domain
    email.split("@").second
  end

  def destroy_demo_data
    DemoData::Destroy.new(user: self).process
  end

  def log_event(category)
    UserEvent.create(
      category:,
      user: self,
    )
  end
end
