# frozen_string_literal: true

require 'jekyll'
require_relative 'premonition/commands/install_scss.rb'
require_relative 'premonition/attributes/error'
require_relative 'premonition/attributes/stacker'
require_relative 'premonition/attributes/parser'
require_relative 'premonition/version'
require_relative 'premonition/processor'
require_relative 'premonition/resources'
require_relative 'premonition/hook'

module Jekyll
  module Premonition
  end
end
