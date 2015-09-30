class Hash
  def to_hash_recursive
    result = self.to_hash

    result.each do |key, value|
      case value
        when Hash
          result[key] = value.to_hash_recursive
        when Array
          result[key] = value.to_hash_recursive
      end
    end

    result
  end

  def sort_by_key(recursive = false, &block)
    self.keys.sort(&block).reduce({}) do |seed, key|
      seed[key] = self[key]
      if recursive && seed[key].is_a?(Hash)
        seed[key] = seed[key].sort_by_key(true, &block)
      end
      seed
    end
  end
end

class Array
  def to_hash_recursive
    result = self

    result.each_with_index do |value,i|
      case value
        when Hash
          result[i] = value.to_hash_recursive
        when Array
          result[i] = value.to_hash_recursive
      end
    end

    result
  end
end
