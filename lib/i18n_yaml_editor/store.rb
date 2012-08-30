# encoding: utf-8

require "set"
require "pathname"

require "i18n_yaml_editor/transformation"
require "i18n_yaml_editor/key"

module I18nYamlEditor
  class Store
    include Transformation

    def initialize *new_keys
      self.keys = Set.new
      new_keys.each {|key| self.keys.add(key)}
    end

    attr_accessor :keys

    def filter_keys options={}
      filters = []
      if options.has_key?(:key)
        filters << lambda {|k| k.key =~ options[:key]} 
      end
      if options.has_key?(:complete)
        filters << lambda {|k| key_complete?(k.key) == options[:complete]}
      end
      if options.has_key?(:text)
        filters << lambda {|k| k.text =~ options[:text]} 
      end

      self.keys.select {|k|
        filters.all? {|filter| filter.call(k)}
      }
    end

    def key_categories
      self.keys.map {|k| k.key.split(".").first}.uniq
    end

    def locales
      self.keys.map(&:locale).uniq
    end

    def find_key params
      self.keys.detect {|key|
        params.all? {|k,v| key.send(k) == v}
      }
    end

    def find_keys params
      self.keys.select {|key|
        params.all? {|k,v| key.send(k) == v}
      }
    end

    def update_key key, locale, text
      key = find_key(:key => key, :locale => locale)
      key.text = text
    end

    def key_complete? key
      keys = self.find_keys(:key => key)
      keys.all? {|k| k.text.to_s !~ /\A\s*\z/}
    end

    def category_complete? category
      keys = self.filter_keys(:key => /^#{category}\./)
      keys.all? {|k| key_complete?(k.key)}
    end

    def create_missing_keys
      unique_keys = self.keys.map(&:key).uniq
      unique_keys.each {|key|
        existing_translations = self.keys.select {|k| k.key == key}
        missing_translations = self.locales - existing_translations.map(&:locale)
        missing_translations.each {|locale|
          path = Pathname.new(existing_translations.first.file)
          dirs, file = path.split
          file = file.to_s.split(".")
          file[-2] = locale
          file = file.join(".")
          path = dirs.join(file).to_s
          new_key = Key.new(:locale => locale, :key => key, :file => path, :text => "")
          self.keys.add(new_key)
        }
      }
    end

    def from_yaml yaml, file=nil
      keys = flatten_hash(yaml)
      keys.each {|full_key, text|
        _, locale, key_name = full_key.match(/^(.*?)\.(.*)/).to_a
        key = Key.new(:key => key_name, :file => file, :locale => locale, :text => text)
        self.keys.add(key)
      }
    end

    def to_yaml
      result = {}
      files = self.keys.group_by(&:file)
      files.each {|file, file_keys|
        file_result = {}
        file_keys.each {|key|
          file_result[key.full_key] = key.text
        }
        result[file] = nest_hash(file_result)
      }
      result
    end
  end
end
