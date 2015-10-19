require 'i18n_yaml_editor'

iye_app = I18nYamlEditor::App.new('example')
iye_app.load_translations
iye_app.store.create_missing_keys

# mounted on path as (rails)-integration example and for testing
map('/dev/iye') { run I18nYamlEditor::Web.app_stack(iye_app) }
