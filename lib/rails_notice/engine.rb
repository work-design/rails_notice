require 'rails_com'
module RailsNotice
  class Engine < ::Rails::Engine

    config.autoload_paths += Dir[
      "#{config.root}/app/models/announcement",
      "#{config.root}/app/models/notification"
    ]

    config.eager_load_paths += Dir[
      "#{config.root}/app/models/announcement",
      "#{config.root}/app/models/notification"
    ]

    config.generators do |g|
      g.rails = {
        system_tests: false,
        assets: false,
        stylesheets: false,
        helper: false
      }
      g.templates.unshift File.expand_path('lib/templates', RailsCom::Engine.root)
    end

  end
end
