# encoding: utf-8

require "set"
require "pathname"

require "i18n_yaml_editor/transformation"
require "i18n_yaml_editor/category"
require "i18n_yaml_editor/key"
require "i18n_yaml_editor/translation"

module I18nYamlEditor
  class Store
    include Transformation

    attr_accessor :categories, :keys, :translations, :locales

    def initialize
      @categories = {}
      @keys = {}
      @translations = {}
      @locales = Set.new
    end

    def add_translation translation
      self.translations[translation.name] = translation

      add_locale(translation.locale)

      key = (self.keys[translation.key] ||= Key.new(name: translation.key))
      key.add_translation(translation)

      category = (self.categories[key.category] ||= Category.new(name: key.category))
      category.add_key(key)
    end

    def add_key key
      self.keys[key.name] = key
    end

    def add_locale locale
      self.locales.add(locale)
    end

    def filter_keys options={}
      filters = []
      if options.has_key?(:key)
        filters << lambda {|k| k.name =~ options[:key]} 
      end
      if options.has_key?(:complete)
        filters << lambda {|k| k.complete? == options[:complete]}
      end
      if options.has_key?(:text)
        filters << lambda {|k|
          k.translations.any? {|t| t.text =~ options[:text]}
        }
      end

      self.keys.select {|name, key|
        filters.all? {|filter| filter.call(key)}
      }
    end

    def key_categories
      self.keys.map {|k| k.key.split(".").first}.uniq
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

    def category_complete? category
      keys = self.filter_keys(:key => /^#{category}\.?.*\z/)
      keys.all? {|k| key_complete?(k.key)}
    end

    def create_missing_keys
      self.keys.each {|name, key|
        missing_locales = self.locales - key.translations.map(&:locale)
        missing_locales.each {|locale|
          translation = key.translations.first

          # this just replaces the locale part of the file name. should
          # be possible to do in a simpler way. gsub, baby.
          path = Pathname.new(translation.file)
          dirs, file = path.split
          file = file.to_s.split(".")
          file[-2] = locale
          file = file.join(".")
          path = dirs.join(file).to_s

          new_translation = Translation.new(name: "#{locale}.#{key.name}", file: path)
          add_translation(new_translation)
        }
      }
    end

    def from_yaml yaml, file=nil
      translations = flatten_hash(yaml)
      translations.each {|name, text|
        translation = Translation.new(name: name, text: text, file: file)
        add_translation(translation)
      }
    end

    def to_yaml
      result = {}
      files = self.translations.values.group_by(&:file)
      files.each {|file, translations|
        file_result = {}
        translations.each {|translation|
          file_result[translation.name] = translation.text
        }
        result[file] = nest_hash(file_result)
      }
      result
    end
  end
end
