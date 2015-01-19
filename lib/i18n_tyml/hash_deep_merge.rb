class Hash
  def has_nested_key?(key)
    h = self
    key.to_s.split('^').each do |segment|
      return false unless h.key?(segment)
      h = h[segment]
    end
    true
  end

  # idea snatched from deep_merge in Rails source code
  def deep_safe_merge(other_hash)
    self.merge(other_hash) do |key, oldval, newval|
      oldval = oldval.to_hash if oldval.respond_to?(:to_hash)
      newval = newval.to_hash if newval.respond_to?(:to_hash)
      if oldval.class.to_s == 'Hash'
        if newval.class.to_s == 'Hash'
          oldval.deep_safe_merge(newval)
        else
          oldval
        end
      else
        newval
      end
    end
  end

  def deep_safe_merge!(other_hash)
    replace(deep_safe_merge(other_hash))
  end
end
