require "cuba"
require "cuba/render"

module I18nYamlEditor
  class WebEditor < Cuba
    plugin Cuba::Render
    settings[:render][:template_engine] = "erb"

    def app
      I18nYamlEditor.app
    end

    define do
      on get do
        on param("filter") do |filter|
          keys = app.store.filter_keys(/#{filter}/)
            keys = keys.sort_by(&:key)
          res.write view("translations.html", keys: keys, filter: filter)
        end

        on default do
          categories = app.store.key_categories
          res.write view("index.html", categories: categories, filter: "")
        end
      end

      on post, param("keys") do |keys|
        keys.each {|key, locales|
          locales.each {|locale, text|
            app.store.update_key(key, locale, text)
            #k = IYE.keys.find {|k| k[:key] == key && k[:locale] == locale}
            #k[:text] = text
          }
        }
        app.save_yaml

        res.redirect "/?filter=#{req["filter"]}"
      end
    end
  end
end
