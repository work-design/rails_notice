$:.push File.expand_path('../lib', __FILE__)
require 'rails_notice/version'

Gem::Specification.new do |s|
  s.name = 'rails_notice'
  s.version = RailsNotice::VERSION
  s.authors = ['qinmingyuan']
  s.email = ["mingyuan0715@foxmail.com"]
  s.homepage = 'https://github.com/yougexiangfa/rails_notice'
  s.summary = "Summary of RailsNotice."
  s.description = "Description of RailsNotice."
  s.license = 'MIT'

  s.files = Dir[
    "{app,config,db,lib}/**/*",
    "LICENSE",
    "Rakefile",
    "README.md"
  ]

  s.add_dependency 'rails', '>= 5.0.1'
end
