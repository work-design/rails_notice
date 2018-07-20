module TheNotify
  class Engine < ::Rails::Engine

    initializer 'the_notify.assets.precompile' do |app|
      app.config.assets.precompile += ['the_notify_manifest.js']
    end

  end
end
