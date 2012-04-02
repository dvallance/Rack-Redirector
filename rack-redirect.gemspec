# -*- encoding: utf-8 -*-
#$:.push File.expand_path("../lib", __FILE__)
#require "rack/redirect/version"
require "./lib/rack/redirect/version"

Gem::Specification.new do |s|
  s.name        = "rack-redirect"
  s.version     = Rack::Redirect::VERSION
  s.authors     = ["David Vallance"]
  s.email       = ["dave@davevallance.info"]
  s.homepage    = "http://davevallance.info"
  s.summary     = %q{A simple app to redirect old urls to new ones}
  s.description = <<-EOF
    This is a simple rack middleware app that allows an easy way to specify url redirects. By default it will use a CSV file to load old\new url routes into memory and then check each new request to see if it should or should not be redirected.
  EOF
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

end
