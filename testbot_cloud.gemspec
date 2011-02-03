# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "testbot_cloud/version"

Gem::Specification.new do |s|
  s.name        = "testbot_cloud"
  s.version     = TestbotCloud::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Joakim Kolsjö"]
  s.email       = ["joakim.kolsjo@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Run your tests in the cloud}
  s.description = %q{A tool for creating testbot clusters in the cloud}

  s.rubyforge_project = "testbot_cloud"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
