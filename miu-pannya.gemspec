# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'miu-pannya/version'

Gem::Specification.new do |gem|
  gem.authors       = ["Haruto Otake"]
  gem.email         = ["trapezoid.g@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "miu-pannya"
  gem.require_paths = ["lib"]
  gem.version       = Miu::Pannya::VERSION

  gem.add_dependency 'miu'
  gem.add_dependency 'websocket-rack'
  gem.add_dependency 'msgpack-rpc'
  gem.add_dependency 'thin'
end
