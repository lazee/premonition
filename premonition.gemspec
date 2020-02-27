require File.join([File.dirname(__FILE__), 'lib', 'premonition', 'version.rb'])
Gem::Specification.new do |s|
  s.name = 'premonition'
  s.version = Jekyll::Premonition::VERSION
  s.authors = ['Jakob Vad Nielsen']
  s.email = ['jakobvadnielsen@gmail.com']
  s.license = 'MIT'
  s.homepage = 'http://github.com/lazee/premonition'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Jekyll generator that will convert special block quotes into message boxes.'
  s.files = Dir['LICENSE', 'README.md', 'lib/**/*']
  s.require_paths << 'lib'
  s.test_files = s.files.grep(%r{^(test|spec|features)/})
  s.extra_rdoc_files = ['README.md']

  s.add_dependency 'jekyll', '>= 2.0', '< 5.0'
  s.add_development_dependency 'bundler', '~> 1.5'
  s.add_development_dependency 'mocha', '~> 1.11.2'
  s.add_development_dependency 'rake', '~> 13.0.1'
  s.add_development_dependency 'turn', '~> 0.9.7'
end
