$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "grid_data/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "grid_data"
  s.version     = GridData::VERSION
  s.authors     = ["Scott Parrish"]
  s.email       = ["anithri@gmail.com"]
  s.homepage    = "https://github.com/anithri/grid_data"
  s.summary     = "A Library, helpers and views to aid in using JQGrid in Rails."
  s.description = "A Library, helpers and views to aid in using JQGrid in Rails."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 3.2.1"
  s.add_dependency "config_library", "~> 0.0.3"

  s.add_development_dependency "sqlite3"
end
