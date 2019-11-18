class Notice::Admin::AnnunciatesController < Notice::Admin::BaseController
  before_action :set_annunciate, only: [:show, :edit, :update, :destroy]

  def index
    @annunciates = Annunciate.page(params[:page])
  end

  def new
    @annunciate = Annunciate.new
  end

  def create
    @annunciate = Annunciate.new(annunciate_params)

    unless @annunciate.save
      render :new, locals: { model: @annunciate }, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    @annunciate.assign_attributes(annunciate_params)

    unless @annunciate.save
      render :edit, locals: { model: @annunciate }, status: :unprocessable_entity
    end
  end

  def destroy
    @annunciate.destroy
  end

  private
  def set_annunciate
    @annunciate = Annunciate.find(params[:id])
  end

  def annunciate_params
    params.fetch(:annunciate, {}).permit(
    )
  end

end
