class User < ApplicationRecord
  include ImageAttachmentValidatable

  has_secure_password

  validates :email, presence: true, uniqueness: true
  normalizes :email, with: ->(email) { email.strip.downcase }

  generates_token_for :password_reset, expires_in: 15.minutes do
    password_salt&.last(10)
  end

  has_one_attached :avatar

  enum :role, data: 0, recruiter: 1, interviewer: 2, admin: 3, recruiter_admin: 4, super_admin: 5

  validates_image_attachment :avatar

  scope :recruiters, -> { where(role: [:recruiter, :recruiter_admin], active: true).order(:first_name) }
  scope :admins, -> { where(role: :admin, active: true) }
  scope :data, -> { where(role: :data, active: true) }
  scope :owners, -> { where(role: [:admin, :recruiter, :recruiter_admin], active: true).order(:first_name) }
  scope :interviewers, -> { where(role: [:interviewer, :admin], active: true).order(:first_name) }

  def name
    first_name + " " + last_name
  end

  def admin_or_recruiter_admin?
    admin? or recruiter_admin? or super_admin?
  end

  def self.bot
    find_by(email: "bot@crownstack.com")
  end

  def self.aashish
    find_by(email: "aashishdhawan@crownstack.com")
  end

  def openings
    Opening.where(owner: self, active: true)
  end

  def account
    Account.first
  end
end
