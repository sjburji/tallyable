$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "tallyable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "tallyable"
  s.version     = Tallyable::VERSION
  s.authors     = ["Supreeth Burji"]
  s.email       = ["supreeth.burji@jenesystech.com"]
  s.homepage    = "http://www.jenesystech.com"
  s.summary     = "Tally ERP.9 integration using xml api"
  s.description = "A Proof of concept."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE.md", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.12"
  s.add_dependency "settingslogic"
  s.add_dependency "nokogiri"

  s.add_development_dependency "sqlite3"
end
