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

  def self.load_yaml
    files = Dir["locales/**/*.yml"]
    keys = {}
    YAML.load_file(files.first)
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
end

IYE = I18nYamlEditor
