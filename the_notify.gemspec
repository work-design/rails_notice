$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "the_notify/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "the_notify"
  s.version     = TheNotify::VERSION
  s.authors     = ["qinmingyuan"]
  s.email       = ["mingyuan0715@foxmail.com"]
  s.homepage    = 'https://github.com/yigexiangfa/the_notify'
  s.summary     = "Summary of TheNotify."
  s.description = "Description of TheNotify."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency 'rails', '>= 5.0.1'
end
