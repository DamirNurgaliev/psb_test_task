class Api::V1::CoursesController < ActionController::API
  before_action :set_course, only: %i(update destroy)

  def index
    courses = Course.includes(:author, :competencies).order(:title)

    render json: json(courses)
  end

  def show
    course = Course.includes(:author, :competencies).find(params[:id])

    render json: json(course)
  end

  def create
    course = Course.new(course_params)

    if course.save
      render json: json(course), status: :created
    else
      render json: { errors: course.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @course.update(course_params)
      render json: json(@course)
    else
      render json: { errors: @course.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @course.destroy

    head :no_content
  end

  private

  def json(relation)
    relation.as_json(
      only: %i(id title description created_at updated_at),
      include: %i(author competencies)
    )
  end

  def set_course
    @course = Course.find(params[:id])
  end

  def course_params
    params.permit(:title, :description, :author_id, competency_ids: [])
  end
end
