# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "number_converter/version"

Gem::Specification.new do |s|
  s.name        = "number_converter"
  s.version     = NumberConverter::VERSION
  s.authors     = ["Aziz Light"]
  s.email       = ["aziz@azizlight.me"]
  s.homepage    = ""
  s.summary     = %q{Convert numbers to binary, decimal or hexadecimal}
  s.description = %q{Number Converter is a converter that converts a number of base 2, 10 or 16 to a binary, decimal or hexadecimal number.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "minitest", "2.7.0"
  s.add_development_dependency "mynyml-redgreen", "0.7.1"
  s.add_development_dependency "guard", "0.8.8"
  s.add_development_dependency "guard-minitest", "0.4.0"
  s.add_development_dependency "rb-fsevent", "0.4.3.1"
  s.add_development_dependency "growl_notify", "0.0.3"
end
