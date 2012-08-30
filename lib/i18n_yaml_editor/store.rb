# encoding: utf-8

require "set"

module I18nYamlEditor
  class Store
    def initialize
      @keys = Set.new
    end

    attr_accessor :keys

    def filter_keys filter
      self.keys.select {|k| k.key =~ filter}
    end

    def key_categories
      self.keys.map {|k| k.key.split(".").first}.uniq
    end

    #def to_yaml
      #result = {}
      #files = self.keys.group_by(&:file)
      #files.each {|file, file_keys|
        #file_result = {}
        #file_keys.each {|key|
          #file_result[key.full_key] = key.text
        #}
        #result[file] = IYE.nest_hash(file_result)
      #}
      #result
    #end
  end
end
