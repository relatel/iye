require 'pathname'

module I18nYamlEditor
  LOCALE_PLACEHOLDER = '%LOCALE%'

  ##
  # Root path of gem
  #
  # @return [Pathname]
  def self.root
    @root ||= Pathname.new(File.expand_path('../..', __FILE__))
  end

end

require 'i18n_yaml_editor/app'
require 'i18n_yaml_editor/category'
require 'i18n_yaml_editor/key'
require 'i18n_yaml_editor/store'
require 'i18n_yaml_editor/transformation'
require 'i18n_yaml_editor/translation'
require 'i18n_yaml_editor/web'