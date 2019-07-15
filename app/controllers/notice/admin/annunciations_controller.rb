class Notice::Admin::AnnunciationsController < Notice::Admin::BaseController
  before_action :set_annunciation, only: [:show, :edit, :update, :edit_publish, :update_publish, :options, :wechat, :destroy]

  def index
    q_params = {}
    q_params.merge! default_params
    @annunciations = Annunciation.default_where(q_params).page(params[:page])
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
    @annunciation.assign_attributes(annunciation_params)
    
    if @annunciation.save
      redirect_to admin_annunciations_url
    else
      render :edit
    end
  end
  
  def edit_publish
  
  end

  def update_publish
    if params[:user_tag_ids]
      @annunciation.user_tag_ids = params[:user_tag_ids]
    elsif params[:receiver_type]
      @annunciation.annunciates.create(receiver_type: params[:receiver_type])
    end
    
    #NotificationSettingResetJob.perform_later
    
    redirect_to admin_annunciations_url
  end

  def options
    if params[:receiver_type] == 'User'
      @tags = UserTag.default_where(default_params)
    else
      @tags = UserTag.none
    end
  end
  
  def wechat
  
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
    p = params.fetch(:annunciation, {}).permit(
      :title,
      :body,
      :link,
      :state,
    )
    p.merge! default_params
  end

end
