module TheNotify
  class Engine < ::Rails::Engine

    initializer 'the_notify.assets.precompile' do |app|
      app.config.assets.precompile += ['the_notify_manifest.js']
      app.config.action_mailer.preview_path = File.expand_path('test/mailers/previews', root)
    end

  end
end
