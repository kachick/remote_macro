lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'remote_macro/version'

Gem::Specification.new do |gem|
  gem.name          = 'remote_macro'
  gem.version       = remote_macro::VERSION.dup
  gem.authors       = ['Kenichi Kamiya']
  gem.email         = ['kachick1+ruby@gmail.com']
  gem.licenses      = ['MIT']
  gem.summary       = 'Tiny macro templates on daily operations with remote hosts'
  gem.description   = gem.summary.dup
  gem.homepage      = 'http://kachick.github.com/remote_macro'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.required_ruby_version = '>= 1.9.3'

  gem.add_runtime_dependency 'striuct', '~> 0.4.2'
  gem.add_runtime_dependency 'net-ssh'
  gem.add_runtime_dependency 'net-ssh-shell', '~> 0.2.0'
  gem.add_runtime_dependency 'net-sftp', '~> 2.0.5'

  gem.add_development_dependency 'yard', '~> 0.8'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'bundler'
end
