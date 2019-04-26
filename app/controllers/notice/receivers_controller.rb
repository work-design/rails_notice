class Notice::ReceiversController < ApplicationController

  def search
    if Notification.options_i18n(:receiver_type).values.include?(params[:receiver_type].to_sym) && params[:receiver_type].safe_constantize
      @receivers = params[:receiver_type].safe_constantize.default_where('name-like': params[:q])
      render json: { results: @receivers.as_json(only: [:id], methods: [:name]) }
    else
      render json: { results: [] }
    end
  end

end
