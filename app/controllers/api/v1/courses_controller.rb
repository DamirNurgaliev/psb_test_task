class Api::V1::CoursesController < ActionController::API
  before_action :set_course, only: %i(update destroy)

  def index
    courses = Course.includes(:author, :competencies).order(:title)

    render json: courses.as_json(
      only: %i(id title description created_at updated_at),
      include: %i(author competencies)
    )
  end

  def show
    course = Course.includes(:author, :competencies).find(params[:id])

    render json: course.as_json(
      only: %i(id title description created_at updated_at),
      include: %i(author competencies)
    )
  end

  def create
    course = Course.new(course_params)

    if course.save
      render json: course, status: :created
    else
      render json: { errors: course.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @course.update(course_params)
      render json: @course
    else
      render json: { errors: @course.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @course.destroy

    head :no_content
  end

  private

  def set_course
    @course = Course.find(params[:id])
  end

  def course_params
    params.require(:course).permit(:title, :description, :author_id)
  end
end
