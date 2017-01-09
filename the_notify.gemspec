$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "the_notify/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "the_notify"
  s.version     = TheNotify::VERSION
  s.authors     = ["qinmingyuan"]
  s.email       = ["mingyuan0715@foxmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of TheNotify."
  s.description = "TODO: Description of TheNotify."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.1"

  s.add_development_dependency "sqlite3"
end
