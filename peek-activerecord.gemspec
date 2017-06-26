# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "peek-activerecord/version"

Gem::Specification.new do |spec|
  spec.name          = "peek-activerecord"
  spec.version       = Peek::Activerecord::VERSION
  spec.authors       = ["Ben Lavender"]
  spec.email         = ["blavender@gmail.com"]

  spec.summary       = %q{Peek plugin for activerecord queries and timings}
  spec.homepage      = "https://github.com/bhuga/peek-activerecord"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency 'peek'
  spec.add_dependency 'pygments.rb'

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "pry", '~> 0'
end
