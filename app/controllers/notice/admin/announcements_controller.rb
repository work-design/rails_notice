module Notice
  class Admin::AnnouncementsController < Admin::BaseController
    before_action :set_announcement, only: [
      :show, :edit, :update, :destroy, :actions, :options
    ]

    def index
      q_params = {}
      q_params.merge! default_params
      q_params.merge! params.permit(:type)

      @announcements = Announcement.with_attached_cover.default_where(q_params).order(id: :desc).page(params[:page])
    end

    def create
      @announcement = Announcement.new(announcement_params)
      @announcement.publisher = current_user if defined? current_user

      unless @announcement.save
        render :new, locals: { model: @announcement }, status: :unprocessable_entity
      end
    end

    def edit_user
      @user_tags = Auth::UserTag.where.not(id: @announcement.user_tag_ids)
    end

    def update_user
      params[:user_tag_ids].reject(&:blank?).each do |user_tag_id|
        @announcement.annunciates.find_or_create_by(user_tag_id: user_tag_id)
      end
    end

    def options
      @tags = UserTag.default_where(default_params)
    end



    private
    def set_announcement
      @announcement = Announcement.find(params[:id])
    end

    def announcement_params
      p = params.fetch(:announcement, {}).permit(
        :title,
        :body,
        :link,
        :cover,
        :type
      )
      p.merge! default_form_params
    end

  end
end
