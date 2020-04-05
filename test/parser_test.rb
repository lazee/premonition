# frozen_string_literal: true

require 'test_helper'

class ParserTest < Test::Unit::TestCase

  # def setup; end

  # def teardown; end

  def test_parse1
    parser = Jekyll::Premonition::Attributes::Parser.new('> "info" [  foo = still ] ')
    assert_equal(1, parser.attributes.length)
    parser = Jekyll::Premonition::Attributes::Parser.new('> "info" [  foo = still, bar = got, zot="it.\\" \\\\"  ] ')
    assert_equal(3, parser.attributes.length)
    assert_equal('still', parser.attributes['foo'])
    assert_equal('got', parser.attributes['bar'])
    assert_equal('it." \\', parser.attributes['zot'])
  end

  def test_parse_illegal_keys
    assert_raise Jekyll::Premonition::Attributes::ParserError do
      Jekyll::Premonition::Attributes::Parser.new('[  fo o = still, bar = got, zot="it"  ] ')
    end
    assert_raise Jekyll::Premonition::Attributes::ParserError do
      Jekyll::Premonition::Attributes::Parser.new('[  fo$o = still, bar = got, zot="it"  ] ')
    end
    assert_raise Jekyll::Premonition::Attributes::ParserError do
      Jekyll::Premonition::Attributes::Parser.new('[  ,foo = still, bar = got, zot="it"  ] ')
    end
    assert_raise Jekyll::Premonition::Attributes::ParserError do
      Jekyll::Premonition::Attributes::Parser.new('[  foo = still, bar = got, zot="it",  ] ')
    end
  end

  def test_parse_missing_keys
    assert_raise Jekyll::Premonition::Attributes::ParserError do
      Jekyll::Premonition::Attributes::Parser.new('  foo = still, bar = got, zot="it"  ] ')
    end

    assert_raise Jekyll::Premonition::Attributes::ParserError do
      Jekyll::Premonition::Attributes::Parser.new(' [ foo = still, bar = got, zot="it" ')
    end

    assert_raise Jekyll::Premonition::Attributes::ParserError do
      Jekyll::Premonition::Attributes::Parser.new(' [ foo = still, bar  got, zot="it" ')
    end
  end
end
