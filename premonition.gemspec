require File.join([File.dirname(__FILE__), 'lib', 'premonition', 'version.rb'])
Gem::Specification.new do |s|
  s.name = 'premonition'
  s.version = Jekyll::Premonition::VERSION
  s.authors = ['Jakob Vad Nielsen']
  s.email = ['jakob.nielsen@amedia.no']
  s.license = 'MIT'
  s.homepage = 'http://github.com/amedia/premonition'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Jekyll generator that will convert special block quotes into message boxes.'

  s.files = `git ls-files -z`.split("\x0")
  s.test_files = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']
  s.has_rdoc = false
  s.extra_rdoc_files = ['README.md']

  s.add_development_dependency 'bundler', '~> 1.5'
  s.add_development_dependency 'jekyll', '>= 2.0', '< 3.0'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 3.0'
end
