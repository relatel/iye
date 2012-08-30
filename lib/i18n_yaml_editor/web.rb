require "cuba"
require "cuba/render"

class I18nYamlEditor::Web < Cuba
  plugin Cuba::Render
  settings[:render][:template_engine] = "erb"

  define do
    on get do
      on param("filter") do |filter|
        keys = IYE.store.filter_keys(/#{filter}/)
        keys = keys.sort_by(&:key)
        res.write view("translations.html", keys: keys, filter: filter)
      end

      on default do
        categories = IYE.store.key_categories
        res.write view("index.html", categories: categories, filter: "")
      end
    end

    on post, param("keys") do |keys|
      keys.each {|key, locales|
        locales.each {|locale, text|
          IYE.store.update_key(key, locale, text)
          #k = IYE.keys.find {|k| k[:key] == key && k[:locale] == locale}
          #k[:text] = text
        }
      }
      IYE.store.save_yaml

      res.redirect "/?filter=#{req["filter"]}"
    end
  end
end
