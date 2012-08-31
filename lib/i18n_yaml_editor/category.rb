# encoding: utf-8

require "set"

module I18nYamlEditor
  class Category
    attr_accessor :name, :keys

    def initialize attributes={}
      @name = attributes[:name]
      @keys = Set.new
    end

    def add_key key
      self.keys.add(key)
    end

    def complete?
      self.keys.all? {|key| key.complete?}
    end
  end
end
