require 'i18n_yaml_editor'

# mounted on path as (rails)-integration example and for testing
map('/dev/iye') {
  iye_app = I18nYamlEditor::App.new('example')
  run I18nYamlEditor::Web.app_stack(iye_app)
}
