class UserAnnunciation < Annunciation
  include RailsNotice::Annunciation::UserAnnunciation
end unless defined? UserAnnunciation
