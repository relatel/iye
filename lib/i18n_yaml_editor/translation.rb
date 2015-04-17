# encoding: utf-8

module I18nYamlEditor
  class Translation
    attr_accessor :name, :file, :text

    def initialize attributes={}
      @name, @file, @text = attributes.values_at(:name, :file, :text)
    end

    def text
      if @text.is_a?(String) && @text.match(/\A\s*\z/)
        nil
      else
        @text
      end
    end

    def key
      @key ||= self.name.split(".")[1..-1].join(".")
    end

    def locale
      @locale ||= self.name.split(".").first
    end
  end
end
