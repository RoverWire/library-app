# frozen_string_literal: true

class User < ApplicationRecord
  has_many :loans, dependent: :delete_all
  has_many :book_copies, through: :loans

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :lockable, :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  validates :first_name, :last_name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  enum :role, { member: 0, admin: 1, librarian: 2 }

  def full_name
    "#{first_name} #{last_name}"
  end
end
