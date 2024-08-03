class Api::V1::CompetenciesController < ActionController::API
  before_action :set_competency, only: %i(show update destroy)

  def index
    render json: Competency.order(:name)
  end

  def show
    render json: @competency
  end

  def create
    competency = Competency.new(competency_params)

    if competency.save
      render json: competency, status: :created
    else
      render json: { errors: competency.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @competency.update(competency_params)
      render json: @competency
    else
      render json: { errors: @competency.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @competency.destroy

    head :no_content
  end

  private

  def set_competency
    @competency = Competency.find(params[:id])
  end

  def competency_params
    params.require(:competency).permit(:name)
  end
end
