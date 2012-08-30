require "cuba"
require "cuba/render"

class I18nYamlEditor::Web < Cuba
  plugin Cuba::Render
  settings[:render][:template_engine] = "erb"

  define do
    on get do
      filter = req["filter"]
      keys = if filter
               IYE.keys.select {|k| k[:key] =~ /#{filter}/}
             else
               IYE.keys
             end

      keys = keys.sort_by {|k| k.values_at(:key, :locale)}.group_by {|k| k[:key]}

      res.write view("translations.html", keys: keys, filter: filter)
    end

    on post, param("keys") do |keys|
      keys.each {|key, locales|
        locales.each {|locale, text|
          k = IYE.keys.find {|k| k[:key] == key && k[:locale] == locale}
          k[:text] = text
        }
      }
      IYE.dump_yaml
      res.redirect "/?filter=#{req["filter"]}"
    end
  end
end
