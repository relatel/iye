# encoding: utf-8

module I18nYamlEditor
  class Key
    attr_accessor :key, :locale, :file, :text

    def initialize attributes={}
      @key, @locale, @file, @text =
        attributes.values_at(:key, :locale, :file, :text)
    end
  end
end
