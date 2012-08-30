# encoding: utf-8

require "set"

module I18nYamlEditor
  class Store
    def initialize *new_keys
      self.keys = Set.new
      new_keys.each {|key| self.keys.add(key)}
    end

    attr_accessor :keys

    def filter_keys filter
      self.keys.select {|k| k.key =~ filter}
    end

    def key_categories
      self.keys.map {|k| k.key.split(".").first}.uniq
    end

    def find_key params
      self.keys.detect {|key|
        params.all? {|k,v| key.send(k) == v}
      }
    end

    def update_key key, locale, text
      key = find_key(:key => key, :locale => locale)
      key.text = text
    end

    def to_yaml
      result = {}
      files = self.keys.group_by(&:file)
      files.each {|file, file_keys|
        file_result = {}
        file_keys.each {|key|
          file_result[key.full_key] = key.text
        }
        result[file] = IYE.nest_hash(file_result)
      }
      result
    end
  end
end
