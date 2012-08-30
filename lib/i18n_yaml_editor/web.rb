require "cuba"
require "cuba/render"

require "i18n_yaml_editor/app"

module I18nYamlEditor
  class Web < Cuba
    plugin Cuba::Render

    settings[:render][:template_engine] = "erb"
    settings[:render][:views] = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "views"))

    use Rack::ShowExceptions

    def app
      I18nYamlEditor.app
    end

    define do
      on get, root do
        on param("filter") do |filter|
          keys = app.store.filter_keys(/#{filter}/)
          keys = keys.group_by(&:key)
          res.write view("translations.html", keys: keys, filter: filter)
        end

        on default do
          categories = app.store.key_categories
          res.write view("index.html", categories: categories, filter: "")
        end
      end

      on post, "update" do
        if keys = req["keys"]
          keys.each {|key, locales|
            locales.each {|locale, text|
              app.store.update_key(key, locale, text)
            }
          }
          app.save_translations
        end

        res.redirect "/?filter=#{req["filter"]}"
      end

      on get, "debug" do
        res.write partial("debug.html", keys: app.store.keys)
      end
    end
  end
end
