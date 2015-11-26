# encoding: utf-8

module I18nYamlEditor
  class TransformationError < StandardError; end

  module Transformation
    def flatten_hash hash, namespace=[], tree={}
      hash.each {|key, value|
        child_ns = namespace.dup << key
        if value.is_a?(Hash)
          flatten_hash value, child_ns, tree
        else
          tree[child_ns.join(".")] = value
        end
      }
      tree
    end
    module_function :flatten_hash

    def nest_hash hash
      result = {}
      hash.each {|key, value|
        begin
          sub_result = result
          keys = key.split(".")
          keys.each_with_index {|k, idx|
            if keys.size - 1 == idx
              sub_result[k.to_s] = value
            else
              sub_result = (sub_result[k.to_s] ||= {})
            end
          }
        rescue => e
          raise TransformationError.new("Failed to nest key: #{key.inspect} with value: #{value.inspect}")
        end
      }
      result
    end
    module_function :nest_hash

    ##
    # Replaces from_locale with to_locale in filename of path
    # Supports filenames with locale prefix or suffix
    #
    # @param [String] from_locale
    # @param [String] to_locale
    # @param [String] path
    #
    # @example Get path for en locale path from existing dk locale path
    #   Transformation.replace_locale_in_path('dk', 'en', '/tmp/dk.foo.yml') #=> "/tmp/en.foo.yml"
    #   Transformation.replace_locale_in_path('dk', 'en', '/tmp/foo.dk.yml') #=> "/tmp/foo.en.yml"
    #
    # @return [String]
    def replace_locale_in_path(from_locale, to_locale, path)
      parts = File.basename(path).split('.')
      parts[parts.index(from_locale)] = to_locale
      File.join(File.dirname(path), parts.join('.'))
    end
    module_function :replace_locale_in_path
  end
end
