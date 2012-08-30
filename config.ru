$:.unshift("lib")

require "i18n_yaml_editor/app"
require "i18n_yaml_editor/web"

app = I18nYamlEditor::App.new("example")
app.load_translations
app.store.create_missing_keys

run I18nYamlEditor::Web
