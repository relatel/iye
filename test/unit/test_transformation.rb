# encoding: utf-8

require "test_helper"
require "i18n_yaml_editor/transformation"

class TestTransformation < Minitest::Test
  def test_flatten_hash
    input = {
      "da" => {
        "session" => {"login" => "Log ind", "logout" => "Log ud"}
      },
      "en" => {
        "session" => {"login" => "Log in", "logout" => "Log out"}
      }
    }
    expected = {
      "da.session.login" => "Log ind",
      "da.session.logout" => "Log ud",
      "en.session.login" => "Log in",
      "en.session.logout" => "Log out"
    }

    assert_equal expected, Transformation.flatten_hash(input)
  end

  def test_nest_hash
    input = {
      "da.session.login" => "Log ind",
      "da.session.logout" => "Log ud",
      "en.session.login" => "Log in",
      "en.session.logout" => "Log out"
    }
    expected = {
      "da" => {
        "session" => {"login" => "Log ind", "logout" => "Log ud"}
      },
      "en" => {
        "session" => {"login" => "Log in", "logout" => "Log out"}
      }
    }

    assert_equal expected, Transformation.nest_hash(input)
  end

  def test_replace_locale_in_path_suffixed
    assert_equal '/tmp/en.foo.yml', Transformation.replace_locale_in_path('dk', 'en', '/tmp/dk.foo.yml')
  end

  def test_create_missing_translations_in_prefix_named_file
    assert_equal '/tmp/foo.en.yml', Transformation.replace_locale_in_path('dk', 'en', '/tmp/foo.dk.yml')
  end
end
