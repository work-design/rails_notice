Gem::Specification.new do |s|
  s.name = 'rails_notice'
  s.version = '1.0.3'
  s.authors = ['qinmingyuan']
  s.email = ['mingyuan0715@foxmail.com']
  s.homepage = 'https://github.com/work-design/rails_notice'
  s.summary = 'Notification Center for Rails Application'
  s.description = 'Description of RailsNotice.'
  s.license = 'MIT'

  s.files = Dir[
    '{app,config,db,lib}/**/*',
    'LICENSE',
    'Rakefile',
    'README.md'
  ]

  s.add_dependency 'rails_com', '~> 1.2'
end
