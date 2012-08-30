# encoding: utf-8

require "test_helper"

class TestKey < MiniTest::Unit::TestCase
  def test_full_key
    key = IYE::Key.new(:key => "session.login", :locale => "da")

    assert_equal "da.session.login", key.full_key
  end
end
