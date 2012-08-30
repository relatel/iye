require "yaml"
require "set"

require "i18n_yaml_editor/app"
require "i18n_yaml_editor/web"
require "i18n_yaml_editor/web_editor"
require "i18n_yaml_editor/store"
require "i18n_yaml_editor/key"

module I18nYamlEditor
  class << self
    attr_accessor :app
  end

  def self.flatten_hash hash, namespace=[], tree={}
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

  def self.nest_hash hash
    result = {}
    hash.each {|key, value|
      sub_result = result
      keys = key.split(".")
      keys.each {|k|
        if keys.last == k
          sub_result[k.to_sym] = value
        else
          sub_result = (sub_result[k.to_sym] ||= {})
        end
      }
    }
    result
  end

  def self.startup path
    files = Dir[path + "/**/*.yml"]
    files.each {|file|
      yaml = YAML.load_file(file)
      load_yaml_to_database(yaml, file)
    }
    create_missing_keys
  end

  def self.dump_yaml
      File.open(file, "w") {|f| YAML.dump(yaml, f)}
  end
end

IYE = I18nYamlEditor
