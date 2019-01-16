class Annunciation < ApplicationRecord

  attribute :state, :string, default: 'init'

  belongs_to :publisher, polymorphic: true
  has_many :notifications

  enum state: {
    init: 'init',
    done: 'done'
  }

  def do_trigger(params = {})
    self.trigger_to state: params[:state]

    self.class.transaction do
      self.save!
      to_notification(
        receiver: self.verifier,
        sender: self.publisher,
        link: url_helpers.admin_app_url(id: self.id),
        verbose: true
      ) if self.verifier
    end
  end


end
