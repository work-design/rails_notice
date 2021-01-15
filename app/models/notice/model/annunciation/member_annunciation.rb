module Notice
  module Model::Annunciation::MemberAnnunciation
    extend ActiveSupport::Concern

    included do
      has_many :annunciates, class_name: 'MemberAnnunciate', foreign_key: :annunciation_id, dependent: :destroy
      has_many :departments, through: :annunciates
      has_many :job_titles, through: :annunciates
    end

  end
end
