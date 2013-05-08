class CachedArena
  [:channel, :block].each do |method|
    (class << self; self; end).send(:define_method, method) do |id|
      key = "cached_#{method}_#{id}"
      cache = App.cache.get(key)

      if cache.nil?
        App.cache.set(key, Arena.send(method, id), expires_in: 86400)
        cache = App.cache.get(key)
      end

      return cache
    end
  end
end
