# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "amazon-hacks"
  s.version     = "0.5.1"
  s.authors     = ["Jacob Harris"]
  s.email       = ["jharris@nytimes.com"]
  s.summary     = %q{Various hacks related to Amazon.com's content}
  s.description = %q{Various hacks related to Amazon.com's content}

  s.rubyforge_project = "http://rubyforge.org/projects/amazon-hacks/"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_dependency "color-tools","=1.3.0"
  s.add_dependency "hoe","=1.1.6"
  
  # s.add_runtime_dependency "rest-client"
end
