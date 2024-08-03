class Competency < ApplicationRecord
  has_many :course_competencies, dependent: :destroy
  has_many :courses, through: :course_competencies

  validates :name, presence: true, length: { maximum: 100 }
end
