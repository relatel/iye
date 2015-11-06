module I18nYamlEditor
  class TransformationError < StandardError; end

  module Transformation
    def flatten_hash hash, namespace=[], tree={}
      hash.each {|key, value|
        child_ns = namespace.dup << key
        if value.is_a?(Hash)
          flatten_hash value, child_ns, tree
        else
          tree[child_ns.join('.')] = value
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

    def sub_locale_in_path(path, from_locale, to_locale)
      path
          .sub(/(\/|\.)#{from_locale}\.yml$/, "\\1#{to_locale}.yml")
          .sub(/\/#{from_locale}([^\/]+)\.yml$/, "/#{to_locale}\\1.yml")
    end
    module_function :sub_locale_in_path
  end
end
