# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'flickr/version'

Gem::Specification.new do |gem|

  gem.name          = "flickr-objects"
  gem.version       = Flickr::VERSION
  gem.platform      = Gem::Platform::RUBY
  gem.license       = "MIT"

  gem.description   = %q{This gem is an object-oriented wrapper for the Flickr API.}
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/janko-m/flickr-objects"
  gem.authors       = ["Janko Marohnić"]
  gem.email         = ["janko.marohnic@gmail.com"]

  gem.files         = Dir["README.md", "LICENSE.txt", "lib/**/*"]
  gem.require_path  = "lib"

  gem.required_ruby_version = ">= 1.9.2"
end
