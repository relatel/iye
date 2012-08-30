# encoding: utf-8

require "test_helper"

class TestStore < MiniTest::Unit::TestCase
  def setup
    @store = IYE::Store.new
    @store.keys.replace([
      IYE::Key.new(:key => "session.login", :locale => "da", :text => "Log ind", :file => "/tmp/session.da.yml"),
      IYE::Key.new(:key => "session.logout", :locale => "da", :text => "Log ud", :file => "/tmp/session.da.yml"),
      IYE::Key.new(:key => "session.login", :locale => "en", :text => "Sign in", :file => "/tmp/session.en.yml"),
      IYE::Key.new(:key => "app_name", :locale => "da", :text => "Oversætter", :file => "/tmp/da.yml")
    ])
  end

  def test_filter_keys
    result = @store.filter_keys(/login/)

    assert_equal 2, result.size
    assert_equal %w(da en).sort, result.map(&:locale).sort
    assert_equal "session.login", result.map(&:key).uniq.first
  end

  def test_key_categories
    result = @store.key_categories

    assert_equal %w(app_name session).sort, result.sort
  end

  def test_to_yaml
    result = @store.to_yaml

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

    assert_equal expected, result
  end
end
