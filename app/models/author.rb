class Author < ApplicationRecord
  has_many :courses, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }
  validates :email, presence: true,
                    uniqueness: true,
                    length: { maximum: 255 },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
end
