# encoding: utf-8

require "minitest/autorun"
require "i18n_yaml_editor"

class TestI18nYamlEditor < MiniTest::Unit::TestCase
  def test_setup_database
    IYE.setup_database
    assert IYE.db
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

  def test_full_startup
    IYE.startup("test/assets/full_startup_locales")
    keys = IYE.db[:keys]

    assert_equal 6, keys.count
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

  def test_full_startup
    IYE.startup("test/assets/full_startup_locales")
    keys = IYE.db[:keys]

    assert_equal 6, keys.count
  end

  def test_load_yaml_to_database
    IYE.setup_database

    input = {da: {session: {login: "Log ind"}}}
    IYE.load_yaml_to_database(input)

    keys = IYE.db[:keys]

    assert_equal 1, keys.count
    key = keys.first
    assert_equal "da", key[:locale]
    assert_equal "session.login", key[:key]
    assert_equal "Log ind", key[:text]
  end

  def test_locales
    IYE.setup_database
    keys = IYE.db[:keys]
    keys.insert(:locale => "da")
    keys.insert(:locale => "en")

    assert_equal(%w(da en).sort, IYE.locales.sort)
  end

  def test_create_missing_keys
    IYE.setup_database
    keys = IYE.db[:keys]
    keys.insert(:locale => "da", :key => "session.login")
    keys.insert(:locale => "en", :key => "session.login")

    keys.insert(:locale => "da", :key => "session.logout", :file => "/tmp/session.da.yml")

    IYE.create_missing_keys

    assert_equal 1, keys.where(:locale => "en", :key => "session.logout", :file => "/tmp/session.en.yml").count
  end

  def test_dump_to_files
    IYE.setup_database
    keys = IYE.db[:keys]

    require "tmpdir"
    Dir.mktmpdir {|dir|
      keys.insert(:key => "app_name", :text => "Oversætter", :file => "#{dir}/da.yml", :locale => "da")
      keys.insert(:key => "session.login", :text => "Log ind", :file => "#{dir}/session.da.yml", :locale => "da")
      keys.insert(:key => "session.logout", :text => "Log ud", :file => "#{dir}/session.da.yml", :locale => "da")
      keys.insert(:key => "session.login", :text => "Log in", :file => "#{dir}/session.en.yml", :locale => "en")

      IYE.dump_yaml

      da = YAML.load_file("#{dir}/da.yml")
      da_session = YAML.load_file("#{dir}/session.da.yml")
      en_session = YAML.load_file("#{dir}/session.en.yml")

      assert_equal({da: {app_name: "Oversætter"}}, da)
      assert_equal({da: {session: {login: "Log ind", logout: "Log ud"}}}, da_session)
      assert_equal({en: {session: {login: "Log in"}}}, en_session)
    }
  end
end
