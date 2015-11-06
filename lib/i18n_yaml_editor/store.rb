require 'set'
require 'pathname'

require 'i18n_yaml_editor/transformation'
require 'i18n_yaml_editor/category'
require 'i18n_yaml_editor/key'
require 'i18n_yaml_editor/translation'

module I18nYamlEditor
  class DuplicateTranslationError < StandardError; end

  class Store
    include Transformation

    attr_accessor :categories, :keys, :translations, :locales, :file_radixes

    def initialize
      @categories = {}
      @keys = {}
      @translations = {}
      @locales = Set.new
      @file_radixes = Set.new
    end

    def add_translation(translation)
      if (existing = self.translations[translation.name])
        message = "#{translation.name} detected in #{translation.file} and #{existing.file}"
        raise DuplicateTranslationError.new(message)
      end

      self.translations[translation.name] = translation

      add_locale(translation.locale)
      add_file_radix(translation.file, translation.locale) if translation.file

      key = (self.keys[translation.key] ||= Key.new(name: translation.key))
      key.add_translation(translation)

      category = (self.categories[key.category] ||= Category.new(name: key.category))
      category.add_key(key)
    end

    def add_key(key)
      self.keys[key.name] = key
    end

    def add_locale(locale)
      self.locales.add(locale)
    end

    def add_file_radix(path, locale)
      file_radix = sub_locale_in_path(path, locale, LOCALE_PLACEHOLDER)
      self.file_radixes.add(file_radix)
    end

    def filter_keys(options={})
      filters = []
      if options.has_key?(:key)
        filters << lambda {|k| k.name =~ options[:key]}
      end
      if options.has_key?(:complete)
        filters << lambda {|k| k.complete? == options[:complete]}
      end
      if options.has_key?(:empty)
        filters << lambda {|k| k.empty? == options[:empty]}
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

    def create_missing_keys
      self.keys.each {|name, key|
        missing_locales = self.locales - key.translations.map(&:locale)
        missing_locales.each {|locale|
          translation = key.translations.first

          # this just replaces the locale part of the file name
          path = sub_locale_in_path(translation.file, translation.locale, locale)

          new_translation = Translation.new(name: "#{locale}.#{key.name}", file: path)
          add_translation(new_translation)
        }
      }
    end

    def from_yaml(yaml, file=nil)
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
