# encoding: utf-8

require "test_helper"
require "i18n_yaml_editor/translation"

class TestTranslation < Minitest::Test
  def test_text
    translation = Translation.new(text: "Some string")
    assert_equal "Some string", translation.text
  end

  def test_empty_text_is_nil
    translation = Translation.new(text: "")
    assert_nil translation.text
  end

  def test_text_with_space_is_nil
    translation = Translation.new(text: " ")
    assert_nil translation.text
  end

  def test_text_with_tab_is_nil
    translation = Translation.new(text: "\t")
    assert_nil translation.text
  end

  def test_text_is_array
    translation = Translation.new(text: %w(a b c))
    assert_equal %w(a b c), translation.text
  end

  def test_text_normalize_newlines
    translation = Translation.new(text: "foo\r\nbar")
    assert_equal "foo\nbar", translation.text
  end

  def test_number_of_lines_nil
    translation = Translation.new(text: nil)
    assert_equal 1, translation.number_of_lines
  end

  def test_number_of_lines_single_line
    translation = Translation.new(text: "foo")
    assert_equal 1, translation.number_of_lines
  end

  def test_number_of_lines_multiple_lines
    translation = Translation.new(text: "foo\nbar\nbaz")
    assert_equal 3, translation.number_of_lines
  end

  def test_key
    translation = Translation.new(name: "da.session.login")
    assert_equal "session.login", translation.key
  end

  def test_locale
    translation = Translation.new(name: "da.session.login")
    assert_equal "da", translation.locale
  end
end
