module I18nYamlEditor
  class << self
    attr_accessor :app
  end
end

require "i18n_yaml_editor/app"
require "i18n_yaml_editor/key"
require "i18n_yaml_editor/store"
require "i18n_yaml_editor/transformation"
require "i18n_yaml_editor/web"
