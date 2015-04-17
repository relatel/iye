# encoding: utf-8

module I18nYamlEditor
  class Translation
    attr_accessor :name, :file
    attr_writer :text

    def initialize attributes={}
      @name, @file, @text = attributes.values_at(:name, :file, :text)
    end

    def text
      if @text.is_a?(String)
        if @text.match(/\A\s*\z/)
          nil
        else
          @text.gsub(/\r\n/, "\n")
        end
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

    def number_of_lines
      if text
        text.scan(/\n/).size + 1
      else
        1
      end
    end
  end
end
