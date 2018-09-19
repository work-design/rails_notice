module RailsNotice
  class Engine < ::Rails::Engine

    initializer 'rails_notice.assets.precompile' do |app|
      app.config.assets.precompile += ['rails_notice_manifest.js']
    end

  end
end
