# encoding: utf-8

require "set"

module I18nYamlEditor
  class Key
    attr_accessor :name, :translations

    def initialize attributes={}
      @name = attributes[:name]
      @translations = Set.new
    end

    def add_translation translation
      self.translations.add(translation)
    end

    def category
      @category ||= self.name.split(".").first
    end

    def complete?
      self.translations.all? {|t| t.text.to_s !~ /\A\s*\z/} || empty?
    end

    def empty?
      self.translations.all? {|t| t.text.to_s =~ /\A\s*\z/}
    end
  end
end
