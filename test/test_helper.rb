require 'test/unit'
require 'mocha/test_unit'
require 'premonition'
require 'jekyll'
require 'redcarpet'

begin
  require 'turn'
rescue LoadError
  puts '**********************************************'
  puts 'Install the Turn gem for prettier test output.'
  puts '> gem install turn'
  puts '**********************************************'
end

class Test::Unit::TestCase
end
