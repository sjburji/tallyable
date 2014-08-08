$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "tallyable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "tallyable"
  s.version     = Tallyable::VERSION
  s.authors     = ["Supreeth Burji"]
  s.email       = ["supreethjburji@yahoo.com"]
  s.homepage    = "https://github.com/sjburji/tallyable"
  s.summary     = "Tally ERP 0.9 integration using xml api"
  s.description = "A Proof of concept."
  s.licenses    = ['MIT']
  
  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE.md", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]
end
