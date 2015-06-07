# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'json_api/generators/version'

Gem::Specification.new do |spec|
  spec.name          = 'json_api-generators'
  spec.version       = JsonApi::Generators::VERSION
  spec.authors       = ['Edward Loveall']
  spec.email         = ['edward@intrepid.io']

  spec.summary       = 'Rails generators for common API paradigms used at Intrepid Pursuits.'
  spec.description   = 'We have common API paradigms that we use such as Monban for username / password sign in, omniauth for oauth, plus warden setup with route constraints.'
  spec.homepage      = 'https://github.com/intrepidpursuits'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 10.0'
end
