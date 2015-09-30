# encoding: utf-8

require "test_helper"
require "i18n_yaml_editor/store"

class TestStore < Minitest::Test
  def test_add_translations
    store = Store.new
    translation = Translation.new(:name => "da.session.login")

    store.add_translation(translation)

    assert_equal 1, store.translations.size
    assert_equal translation, store.translations[translation.name]

    assert_equal 1, store.keys.size
    assert_equal Set.new([translation]), store.keys["session.login"].translations

    assert_equal 1, store.categories.size
    assert_equal %w(session.login), store.categories["session"].keys.map(&:name)

    assert_equal 1, store.locales.size
    assert_equal %w(da), store.locales.to_a
  end

  def test_add_duplicate_translation
    store = Store.new
    t1 = Translation.new(:name => "da.session.login")
    t2 = Translation.new(:name => "da.session.login")
    store.add_translation(t1)

    assert_raises(DuplicateTranslationError) {
      store.add_translation(t2)
    }
  end

  def test_filter_keys_on_key
    store = Store.new
    store.add_key(Key.new(name: "session.login"))
    store.add_key(Key.new(name: "session.logout"))

    result = store.filter_keys(key: /login/)

    assert_equal 1, result.size
    assert_equal %w(session.login), result.keys
  end

  def test_filter_keys_on_complete
    store = Store.new
    store.add_translation Translation.new(name: "da.session.login", text: "Log ind")
    store.add_translation Translation.new(name: "en.session.login")
    store.add_translation Translation.new(name: "da.session.logout", text: "Log ud")

    result = store.filter_keys(complete: false)

    assert_equal 1, result.size
    assert_equal %w(session.login), result.keys
  end

  def test_filter_keys_on_empty
    store = Store.new
    store.add_translation Translation.new(name: "da.session.login", text: "Log ind")
    store.add_translation Translation.new(name: "da.session.logout")

    result = store.filter_keys(empty: true)

    assert_equal 1, result.size
    assert_equal %w(session.logout), result.keys
  end

  def test_filter_keys_on_text
    store = Store.new
    store.add_translation Translation.new(name: "da.session.login", text: "Log ind")
    store.add_translation Translation.new(name: "da.session.logout", text: "Log ud")
    store.add_translation Translation.new(name: "da.app.name", text: "Translator")

    result = store.filter_keys(text: /Log/)

    assert_equal 2, result.size
    assert_equal %w(session.login session.logout).sort, result.keys.sort
  end

  def test_create_missing_translations
    store = Store.new
    store.add_translation Translation.new(name: "da.session.login", text: "Log ind", file: "/tmp/session.da.yml")
    store.add_locale("en")

    store.create_missing_keys

    assert(translation = store.translations["en.session.login"])
    assert_equal "en.session.login", translation.name
    assert_equal "/tmp/session.en.yml", translation.file
    assert_nil translation.text
  end

  def test_create_missing_translations_in_top_level_file
    store = Store.new
    store.add_translation Translation.new(name: "da.app_name", text: "Oversætter", file: "/tmp/da.yml")
    store.add_locale("en")

    store.create_missing_keys

    assert(translation = store.translations["en.app_name"])
    assert_equal "en.app_name", translation.name
    assert_equal "/tmp/en.yml", translation.file
    assert_nil translation.text
  end

  def test_from_yaml
    input = {
      da: {
        session: {login: "Log ind"}
      }
    }
    store = Store.new

    store.from_yaml(input)

    assert_equal 1, store.translations.size
    translation = store.translations["da.session.login"]
    assert_equal "da.session.login", translation.name
    assert_equal "Log ind", translation.text
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
    }.with_indifferent_access

    store = Store.new
    store.add_translation Translation.new(name: "da.session.login", text: "Log ind", file: "/tmp/session.da.yml")
    store.add_translation Translation.new(name: "en.session.login", text: "Sign in", file: "/tmp/session.en.yml")
    store.add_translation Translation.new(name: "da.session.logout", text: "Log ud", file: "/tmp/session.da.yml")
    store.add_translation Translation.new(name: "da.app_name", text: "Oversætter", file: "/tmp/da.yml")

    assert_equal expected, store.to_yaml
  end
end
