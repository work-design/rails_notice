module Notice
  class Notification < ApplicationRecord
    include Model::Notification
    include Send::Socket
  end
end
