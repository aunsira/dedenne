# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dedenne/version'

Gem::Specification.new do |spec|
  spec.name          = "dedenne"
  spec.version       = Dedenne::VERSION
  spec.authors       = ["Sira"]
  spec.email         = ["aun.sira@gmail.com"]
  spec.summary       = %q{A video transcoder}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib", "redis", "config"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "streamio-ffmpeg"
  spec.add_development_dependency "aws-sdk"
  spec.add_development_dependency "sinatra"
  spec.add_development_dependency "resque"
  spec.add_development_dependency "foreman"
  spec.add_development_dependency "redis"
end
