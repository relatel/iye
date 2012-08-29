require "yaml"
require "sequel"

class I18nYamlEditor
  class << self
    attr_accessor :db
  end

  def self.setup_database
    self.db = Sequel.sqlite
    self.db.create_table :keys do
      primary_key :id
      String :key
      String :file
      String :locale
      String :text
    end
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
      db[:keys].insert(
        :key => key,
        :file => file,
        :locale => locale,
        :text => text
      )
    }
  end

  def self.locales
    self.db[:keys].distinct.select(:locale).map {|r| r[:locale]}
  end

  def self.create_missing_keys
    locales = self.locales
    keys = self.db[:keys].group_and_count(:key).having("count <> ?", locales.size).all
    keys.each {|row|
      key = row[:key]
      missing = locales -
        self.db[:keys].where(:key => key).select(:locale).map {|r| r[:locale]}
      missing.each {|locale|
        self.db[:keys].insert(:locale => locale, :key => key)
      }
    }
  end

  def self.startup path
    setup_database
    files = Dir[path + "/**/*.yml"]
    files.each {|file|
      yaml = YAML.load_file(file)
      load_yaml_to_database(yaml, file)
    }
  end

  def self.dump_yaml
    keys = self.db[:keys]
    files = keys.all.group_by {|key| key[:file]}
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
