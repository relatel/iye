# encoding: utf-8

require "minitest/autorun"
require "i18n_yaml_editor"

class TestI18nYamlEditor < MiniTest::Unit::TestCase
  def setup
    IYE.keys.clear
  end

  def test_flatten_hash_single_level
    input = {da: {login: "Log ind", logout: "Log ud"}}
    output = {"da.login" => "Log ind", "da.logout" => "Log ud"}
    assert_equal(output, IYE.flatten_hash(input))
  end

  def test_flatten_hash_extended
    input = {
      da: {
        session: {login: "Log ind", logout: "Log ud"}
      },
      en: {
        session: {login: "Log in", logout: "Log out"}
      }
    }
    output = {
      "da.session.login" => "Log ind",
      "da.session.logout" => "Log ud",
      "en.session.login" => "Log in",
      "en.session.logout" => "Log out"
    }

    assert_equal(output, IYE.flatten_hash(input))
  end

  def test_nest_hash
    input = {
      "da.session.login" => "Log ind",
      "da.session.logout" => "Log ud",
      "en.session.login" => "Log in",
      "en.session.logout" => "Log out"
    }
    output = {
      da: {
        session: {login: "Log ind", logout: "Log ud"}
      },
      en: {
        session: {login: "Log in", logout: "Log out"}
      }
    }

    assert_equal(output, IYE.nest_hash(input))
  end
end
