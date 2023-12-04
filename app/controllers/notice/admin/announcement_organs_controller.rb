module Notice
  class Admin::AnnouncementOrgansController < Admin::BaseController
    before_action :set_announcement
    before_action :set_departments, only: [:new, :create]
    before_action :set_new_announcement_organ, only: [:new, :create]

    def index
      @announcement_organs = @annunciation.announcement_organs
    end

    private
    def set_announcement
      @annunciation = Announcement.find params[:annunciation_id]
    end

    def set_departments
      @departments = Org::Department.default_where(default_params)
    end

    def set_new_announcement_organ
      @announcement_organ = @announcement.announcement_organs.build(announcement_organ_params)
    end

    def announcement_organ_params
      params.fetch(:announcement_organ, {}).permit(
        :organ_id
      )
    end

  end
end
