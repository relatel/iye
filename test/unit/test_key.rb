# encoding: utf-8

class TestKey < MiniTest::Unit::TestCase
  attr_accessor :key, :locale, :file, :text

  def initialize *attributes
    @key, @locale, @file, @text =
      attributes.values_at(:key, :locale, :file, :text)
  end
end
