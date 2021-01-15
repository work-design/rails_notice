module Notice
  class Admin::MembersController < Admin::BaseController
    before_action :set_member, only: [:show, :edit, :update]

    def index
      q_params = {}
      q_params.merge! params.permit(:id)

      @members = Member.default_where(q_params).order(id: :desc).page(params[:page])
    end

    def show
    end

    def edit
    end

    def update
      @member.assign_attributes(member_params)

      unless @member.save
        render :edit, locals: { model: @member }, status: :unprocessable_entity
      end
    end

    private
    def set_member
      @member = Member.find(params[:id])
    end

    def member_params
      params.fetch(:member, {}).permit(
        :showtime,
        :accept_email,
        notifiable_types: []
      )
    end

  end
end
