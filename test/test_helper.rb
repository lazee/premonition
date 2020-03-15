# frozen_string_literal: true

require 'test/unit'
require 'mocha/test_unit'
require 'premonition'

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
