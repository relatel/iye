# encoding: utf-8

require "yaml"

require "i18n_yaml_editor"
require "i18n_yaml_editor/web"
require "i18n_yaml_editor/store"

module I18nYamlEditor
  class App
    def initialize path
      @path = File.expand_path(path)
      @store = Store.new
      I18nYamlEditor.app = self
    end

    attr_accessor :store

    def start
      $stdout.puts " * Loading translations from #{@path}"
      load_translations

      $stdout.puts " * Creating missing translations"
      store.create_missing_keys

      $stdout.puts " * Starting web editor at port 5050"
      Rack::Server.start :app => Web, :Port => 5050
    end

    def load_translations
      files = Dir[@path + "/**/*.yml"]
      files.each {|file|
        yaml = YAML.load_file(file)
        store.from_yaml(yaml, file)
      }
    end

    def save_translations
      files = store.to_yaml
      files.each {|file, yaml|
        File.open(file, "w", encoding: "utf-8") {|f| f << yaml.to_yaml}
      }
    end
  end
end
