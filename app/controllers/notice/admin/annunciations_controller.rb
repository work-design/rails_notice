class Notice::Admin::AnnunciationsController < Notice::Admin::BaseController
  before_action :set_annunciation, only: [:show, :edit, :update, :edit_publish, :update_publish, :options, :wechat, :destroy]

  def index
    q_params = {}
    q_params.merge! default_params
    q_params.merge! params.permit(:type)

    @annunciations = Annunciation.includes(annunciates: :user_tag).with_attached_cover.default_where(q_params).order(id: :desc).page(params[:page])
  end

  def new
    @annunciation = Annunciation.new
  end

  def create
    @annunciation = Annunciation.new(annunciation_params)
    @annunciation.publisher = current_user if defined? current_user

    unless @annunciation.save
      render :new, locals: { model: @annunciation }, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    @annunciation.assign_attributes(annunciation_params)

    unless @annunciation.save
      render :edit, locals: { model: @annunciation }, status: :unprocessable_entity
    end
  end

  def edit_publish
    @user_tags = UserTag.where.not(id: @annunciation.user_tag_ids)
  end

  def update_publish
    if params[:user_tag_ids]
      params[:user_tag_ids].reject(&:blank?).each do |user_tag_id|
        @annunciation.annunciates.find_or_create_by(user_tag_id: user_tag_id)
      end
    elsif params[:receiver_type]
      @annunciation.annunciates.create(receiver_type: params[:receiver_type])
    end
  end

  def options
    @tags = UserTag.default_where(default_params)
  end

  def wechat
  end

  def destroy
    @annunciation.destroy
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
      :cover
    )
    p.merge! default_form_params
  end

end
