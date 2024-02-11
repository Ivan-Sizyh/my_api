require "jwt"

class Student < ApplicationRecord
  belongs_to :school_class, foreign_key: :class_id

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :surname, presence: true

  def generate_token
    payload = { student_id: id }
    secret_salt = ENV['SECRET_SALT']
    JWT.encode(payload, secret_salt, 'HS256')
  end

  def valid_token?(token)
    generate_token == token
  end
end
