# encoding: utf-8

require "test_helper"
require "i18n_yaml_editor/key"

class TestKey < MiniTest::Unit::TestCase
  def test_category
    key = Key.new(name: "session.login")
    assert_equal "session", key.category
  end

  def test_complete
    key = Key.new(name: "session.login")
    key.add_translation Translation.new(name: "da.session.login", text: "Log ind")
    key.add_translation Translation.new(name: "en.session.login", text: "Sign in")

    assert key.complete?
  end

  def test_incomplete
    key = Key.new(name: "session.login")
    key.add_translation Translation.new(name: "da.session.login", text: "Log ind")
    key.add_translation Translation.new(name: "en.session.login")

    assert_equal false, key.complete?
  end
end
