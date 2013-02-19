class CachedArena  
  def self.channel(id)
    Generic.cache.set("cached_channel_#{id}", Arena.channel(id))
  end

  def self.block(id)
    Generic.cache.set("cached_block_#{id}", Arena.block(id))
  end
end
