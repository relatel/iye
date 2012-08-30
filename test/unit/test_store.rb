# encoding: utf-8

require "test_helper"
require "i18n_yaml_editor/store"

class TestStore < MiniTest::Unit::TestCase
  def store_with_keys
    Store.new(
      Key.new(:key => "session.login", :locale => "da", :text => "Log ind", :file => "/tmp/session.da.yml"),
      Key.new(:key => "session.logout", :locale => "da", :text => "Log ud", :file => "/tmp/session.da.yml"),
      Key.new(:key => "session.login", :locale => "en", :text => "Sign in", :file => "/tmp/session.en.yml"),
      Key.new(:key => "app_name", :locale => "da", :text => "Oversætter", :file => "/tmp/da.yml")
    )
  end

  def test_filter_keys
    result = store_with_keys.filter_keys(/login/)

    assert_equal 2, result.size
    assert_equal %w(da en).sort, result.map(&:locale).sort
    assert_equal "session.login", result.map(&:key).uniq.first
  end

  def test_key_categories
    result = store_with_keys.key_categories

    assert_equal %w(app_name session).sort, result.sort
  end

  def test_locales
    assert_equal(%w(da en).sort, store_with_keys.locales.sort)
  end

  def test_find_key
    result = store_with_keys.find_key(:key => "session.login", :locale => "da")

    assert_equal "Log ind", result.text
  end

  def test_update_key
    store = store_with_keys

    store.update_key("session.login", "da", "Kom indenfor")

    key = store.find_key(:key => "session.login", :locale => "da")
    assert_equal "Kom indenfor", key.text
  end

  def test_key_complete_with_missing_translations
    store = Store.new(
      Key.new(:key => "session.login", :locale => "en", :text => "Log in"),
      Key.new(:key => "session.login", :locale => "da")
    )

    assert_equal false, store.key_complete?("session.login")
  end

  def test_key_complete_with_all_translations
    store = Store.new(
      Key.new(:key => "session.login", :locale => "en", :text => "Log in"),
      Key.new(:key => "session.login", :locale => "da", :text => "Log ind")
    )

    assert store.key_complete?("session.login")
  end

  def test_create_missing_keys
    store = Store.new(
      Key.new(locale: "da", key: "session.login"),
      Key.new(locale: "en", key: "session.login"),

      Key.new(locale: "da", key: "session.logout", text: "Ud", file: "/tmp/session.da.yml")
    )

    store.create_missing_keys

    key = store.find_key(locale: "en", key: "session.logout")

    assert key
    assert_equal "en", key.locale
    assert_equal "session.logout", key.key
    assert_equal "/tmp/session.en.yml", key.file
    assert_nil key.text
  end

  def test_from_yaml
    input = {
      da: {
        session: {login: "Log ind"}
      }
    }
    store = Store.new

    store.from_yaml(input)

    assert_equal 1, store.keys.size
    key = store.keys.first
    assert_equal "da", key.locale
    assert_equal "session.login", key.key
    assert_equal "Log ind", key.text
  end

  def test_to_yaml
    expected = {
      "/tmp/session.da.yml" => {
        da: {
          session: {
            login: "Log ind",
            logout: "Log ud"
          }
        }
      },
      "/tmp/session.en.yml" => {
        en: {
          session: {
            login: "Sign in"
          }
        }
      },
      "/tmp/da.yml" => {
        da: {
          app_name: "Oversætter"
        }
      }
    }

    assert_equal expected, store_with_keys.to_yaml
  end
end
