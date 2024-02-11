class SchoolClass < ApplicationRecord
  belongs_to :school, foreign_key: :school_id

  has_many :students, foreign_key: :class_id

  validates :number, presence: true
  validates :letter, presence: true
end
