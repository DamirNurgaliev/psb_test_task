class Author < ApplicationRecord
  has_many :courses

  validates :name, presence: true, length: { maximum: 100 }
  validates :email, presence: true,
    uniqueness: true,
    length: { maximum: 255 },
    format: { with: URI::MailTo::EMAIL_REGEXP, message: "Wrong format" }

  #before_destroy :reassign_courses

  private

  def reassign_courses
    new_author = Author.where.not(id: self.id).sample

    if new_author
      courses.update_all(author_id: new_author.id)
    else
      raise ActiveRecord::RecordNotDestroyed, "Cannot delete the last author"
    end
  end
end
