require "yaml"
require "set"

class I18nYamlEditor
  def self.keys
    @keys ||= Set.new
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

  def self.load_yaml_to_database yaml, file=nil
    keys = flatten_hash(yaml)
    keys.each {|full_key, text|
      _, locale, key = full_key.match(/^(.*?)\.(.*)/).to_a
      self.keys.add(
        :key => key,
        :file => file,
        :locale => locale,
        :text => text
      )
    }
  end

  def self.locales
    self.keys.map {|k| k[:locale]}.uniq
  end

  def self.create_missing_keys
    locales = self.locales
    keys = self.keys.map {|k| k[:key]}.uniq
    keys.each {|key|
      existing = self.keys.select {|k| k[:key] == key}
      missing = locales - existing.map {|r| r[:locale]}
      missing.each {|locale|
        file = existing.first[:file].split(".")
        file[-2] = locale
        file = file.join(".")
        self.keys.add(:locale => locale, :key => key, :file => file, :text => nil)
      }
    }
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
    keys = self.keys
    files = keys.group_by {|key| key[:file]}
    files.each {|file, keys|
      res = {}
      keys.each {|key|
        full_key = key.values_at(:locale, :key).join(".")
        res[full_key] = key[:text]
      }
      yaml = nest_hash(res)
      File.open(file, "w") {|f| YAML.dump(yaml, f)}
    }
  end
end

IYE = I18nYamlEditor
