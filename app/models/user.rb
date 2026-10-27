class User < ApplicationRecord
  belongs_to :mechanic, optional: true, inverse_of: :user

  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :taken_in_repairs, class_name: "Repair", foreign_key: :taken_in_by_id, inverse_of: :taken_in_by,  dependent: :restrict_with_error

  enum :role,
       { owner: "owner", 
       mechanic: "mechanic", 
       counter: "counter" }, 
       default: :mechanic, validate: true

  normalizes :email_address, with: ->(email) { email.strip.downcase }

  validates :email_address, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { case_sensitive: false }

  validates :password,
            length: {
              minimum: 10,
              message: "must be at least 10 characters"
            },
            if: -> { password.present? }
end