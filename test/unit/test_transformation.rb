# encoding: utf-8

require "test_helper"
require "i18n_yaml_editor/transformation"

class TestTransformation < Minitest::Test
  def test_flatten_hash
    input = {
      da: {
        session: {login: "Log ind", logout: "Log ud"}
      },
      en: {
        session: {login: "Log in", logout: "Log out"}
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
      da: {
        session: {login: "Log ind", logout: "Log ud"}
      },
      en: {
        session: {login: "Log in", logout: "Log out"}
      }
    }.with_indifferent_access

    assert_equal expected, Transformation.nest_hash(input)
  end
end
