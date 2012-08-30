# encoding: utf-8

require "i18n_yaml_editor/web"

module I18nYamlEditor
  class App
    def initialize path
      @path = File.expand_path(path)
      @store = Store.new
      I18nYamlEditor.app = self
    end

    attr_accessor :store

    def start
      $stderr.puts "* Starting web editor at port 5050"
      Rack::Handler.default.run Web, :Port => 5050
    end
  end
end
