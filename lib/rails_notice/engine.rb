require 'rails_com'
module RailsNotice
  class Engine < ::Rails::Engine

    config.autoload_paths += Dir[
      "#{config.root}/app/models/annunciation"
    ]

    config.eager_load_paths += Dir[
      "#{config.root}/app/models/annunciation"
    ]

    config.generators do |g|
      g.rails = {
        system_tests: false,
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

  end
end
