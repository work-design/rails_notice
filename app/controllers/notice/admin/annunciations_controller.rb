class Notice::Admin::AnnunciationsController < Notice::Admin::BaseController
  before_action :set_annunciation, only: [:show, :edit, :update, :publish, :destroy]

  def index
    @annunciations = Annunciation.page(params[:page])
  end

  def new
    @annunciation = Annunciation.new
  end

  def create
    @annunciation = Annunciation.new(annunciation_params)
    @annunciation.publisher = current_user

    if @annunciation.save
      redirect_to admin_annunciations_url
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @annunciation.update(annunciation_params)
      redirect_to admin_annunciations_url
    else
      render :edit
    end
  end

  def publish
    @annunciation.to_notifications
    NotificationSettingResetJob.perform_later
    redirect_to admin_annunciations_url
  end

  def destroy
    @annunciation.destroy
    redirect_to admin_annunciations_url
  end

  private
  def set_annunciation
    @annunciation = Annunciation.find(params[:id])
  end

  def annunciation_params
    params.fetch(:annunciation, {}).permit(
      :title,
      :body,
      :link,
      :state
    )
  end

end
