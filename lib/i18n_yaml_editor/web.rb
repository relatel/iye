require "cuba"
require "cuba/render"

class I18nYamlEditor::Web < Cuba
  plugin Cuba::Render
  settings[:render][:template_engine] = "erb"

  define do
    on get do
      keys = IYE.db[:keys].all.group_by {|r| r[:key]}
      res.write view("translations.html", keys: keys)
    end
  end
end
