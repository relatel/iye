# encoding: utf-8

require "test_helper"
require "i18n_yaml_editor/translation"

class TestTranslation < Minitest::Test
  def test_key
    translation = Translation.new(name: "da.session.login")
    assert_equal "session.login", translation.key
  end

  def test_locale
    translation = Translation.new(name: "da.session.login")
    assert_equal "da", translation.locale
  end
end
