class Api::V1::AuthorsController < ActionController::API
  before_action :set_author, only: %i(show update destroy)

  def index
    render json: Author.order(:name)
  end

  def show
    render json: @author
  end

  def create
    author = Author.new(author_params)

    if author.save
      render json: author, status: :created
    else
      render json: { errors: author.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @author.update(author_params)
      render json: @author
    else
      render json: { errors: @author.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    result = Authors::Destroy.call(author: @author)

    result.success? ? head(:no_content) : head(:unprocessable_entity)
  end

  private

  def set_author
    @author = Author.find(params[:id])
  end

  def author_params
    params.require(:author).permit(:name, :email)
  end
end
