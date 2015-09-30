# encoding: utf-8

require "psych"
require "yaml"
require 'active_support/all'

require "i18n_yaml_editor"
require "i18n_yaml_editor/web"
require "i18n_yaml_editor/store"
require "i18n_yaml_editor/core_ext"

module I18nYamlEditor
  class App
    def initialize(path, port = 5050)
      @path = File.expand_path(path)
      @port = port
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
      Rack::Server.start :app => Web, :Port => (@port || 5050)
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
        File.open(file, "w", encoding: "utf-8") do |f|
          # Rails
          # I18n.backend.load_translations
          # default_locale_translations = I18n.backend.send(:translations)[locale].with_indifferent_access.to_hash_recursive
          # i18n_yaml = {locale.to_s => default_locale_translations}.sort_by_key(true).to_yaml

          # sort alphabetically:
          # i18n_yaml = yaml.with_indifferent_access.to_hash_recursive.sort_by_key(true).to_yaml
          i18n_yaml = yaml.with_indifferent_access.to_hash_recursive.to_yaml
          process = i18n_yaml.split(/\n/).reject{|e| e == ''}[1..-1]  # remove "---" from first line in yaml

          # add an empty line if yaml tree level changes by 2 or more
          tmp_ary = []
          process.each_with_index do |line, idx|
            tmp_ary << line
            unless process[idx+1].nil?
              this_line_spcs = line.match(/\A\s*/)[0].length
              next_line_spcs = process[idx+1].match(/\A\s*/)[0].length
              tmp_ary << '' if next_line_spcs - this_line_spcs < -2
            end
          end

          output = tmp_ary * "\n"

          f.puts output
        end
      }
    end
  end
end
