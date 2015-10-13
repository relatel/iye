require 'i18n_yaml_editor'

iye_app = I18nYamlEditor::App.new('example')
iye_app.load_translations
iye_app.store.create_missing_keys

run I18nYamlEditor::Web.app_stack(iye_app)
