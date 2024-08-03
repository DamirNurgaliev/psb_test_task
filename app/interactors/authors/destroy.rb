class Authors::Destroy
  include TransactionalInteractor

  delegate :author, to: :context

  def call
    reassign_courses

    context.fail! unless author.destroy
  end

  private

  def reassign_courses
    new_author = Author.where.not(id: author.id).sample

    if new_author
      author.courses.update_all(author_id: new_author.id)
    else
      context.fail!(message: "Can't delete last author")
    end
  end
end
