# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'miu-plugin-pannya/version'

Gem::Specification.new do |gem|
  gem.authors       = ["Haruto Otake"]
  gem.email         = ["trapezoid.g@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "miu-plugin-pannya"
  gem.require_paths = ["lib"]
  gem.version       = Miu::Plugin::Pannya::VERSION

  gem.add_dependency 'miu'
  gem.add_dependency 'reel'
end
