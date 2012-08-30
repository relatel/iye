# encoding: utf-8

require "test_helper"
require "i18n_yaml_editor/key"

class TestKey < MiniTest::Unit::TestCase
  def test_full_key
    key = Key.new(:key => "session.login", :locale => "da")

    assert_equal "da.session.login", key.full_key
  end
end
