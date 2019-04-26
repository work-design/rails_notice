require 'rails_com'
module RailsNotice
  class Engine < ::Rails::Engine

    config.generators do |g|
      g.rails = {
        assets: false,
        stylesheets: false,
        helper: false
      }
      g.test_unit = {
        fixture: true,
        fixture_replacement: :factory_bot
      }
      g.templates.unshift File.expand_path('lib/templates', RailsCom::Engine.root)
    end

    initializer 'rails_notice.assets.precompile' do |app|
      app.config.assets.precompile += ['rails_notice_manifest.js']
    end

  end
end
