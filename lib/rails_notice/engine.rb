module RailsNotice
  class Engine < ::Rails::Engine

    config.eager_load_paths += Dir[
      "#{config.root}/app/models/rails_notice"
    ]

    initializer 'rails_notice.assets.precompile' do |app|
      app.config.assets.precompile += ['rails_notice_manifest.js']
    end

  end
end
