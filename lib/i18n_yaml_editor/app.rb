require 'psych'
require 'yaml'

require 'i18n_yaml_editor'
require 'i18n_yaml_editor/web'
require 'i18n_yaml_editor/store'

module I18nYamlEditor
  class App
    attr_reader :base_path, :rel_path, :full_path
    attr_accessor :store

    def initialize(path)
      @base_path = Dir.pwd
      @rel_path = path
      @full_path = File.expand_path(path, @base_path)
      @store = Store.new
    end

    def load_translations
      files = Dir[full_path + '/**/*.yml']
      files.each do |file|
        yaml = YAML.load_file(file)
        store.from_yaml(yaml, file)
      end
    end

    def save_translations
      files = store.to_yaml
      files.each do |file, yaml|
        File.open(file, 'w', encoding: 'utf-8') { |f| f << yaml.to_yaml }
      end
    end
  end
end
