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

  def test_dump_to_files
    IYE.setup_database
    keys = IYE.db[:keys]

    require "tmpdir"
    Dir.mktmpdir {|dir|
      keys.insert(:key => "da.app_name", :text => "Oversætter", :file => "#{dir}/da.yml")
      keys.insert(:key => "da.session.login", :text => "Log ind", :file => "#{dir}/session.da.yml")
      keys.insert(:key => "da.session.logout", :text => "Log ud", :file => "#{dir}/session.da.yml")
      keys.insert(:key => "en.session.login", :text => "Log in", :file => "#{dir}/session.en.yml")

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
