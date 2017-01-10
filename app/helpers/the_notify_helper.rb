module TheNotifyHelper

  def js_load(filename = nil, root: Rails.root, **options)
    filename ||= "controllers/#{controller_path}/#{action_name}"
    path = root + 'app/assets/javascripts' + filename.to_s
    if File.exist?(path.to_s + '.js') || File.exist?(path.to_s + '.js.erb')
      javascript_include_tag filename, options
    end
  end

end