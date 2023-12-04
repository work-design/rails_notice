module Notice
  class Admin::MemberAnnunciatesController < Admin::BaseController
    before_action :set_annunciation
    before_action :set_departments, only: [:new, :create]
    before_action :set_new_member_annunciate, only: [:new, :create]

    def index
      @member_annunciates = @annunciation.annunciates
    end

    private
    def set_annunciation
      @annunciation = Annunciation.find params[:annunciation_id]
    end

    def set_departments
      @departments = Org::Department.default_where(default_params)
    end

    def set_new_member_annunciate
      @member_annunciate = @annunciation.annunciates.build(member_annunciate_params)
    end

    def member_annunciate_params
      params.fetch(:member_annunciate, {}).permit(
        :department_id
      )
    end

  end
end
