# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'drunken_sakana/version'

Gem::Specification.new do |spec|
  spec.name          = 'drunken_sakana'
  spec.version       = DrunkenSakana::VERSION
  spec.authors       = ['Yuya TAMANO']
  spec.email         = ['everfree.main@gmail.com']

  spec.summary       = 'Simple Object/XML mapper.'
  spec.description   = 'See README.md for more information.'
  spec.homepage      = 'https://github.com/tamano/drunken_sakana'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  if spec.respond_to?(:metadata)
    # spec.metadata['allowed_push_host']
  end

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'codeclimate-test-reporter'
  spec.add_development_dependency 'rubocop'
end
