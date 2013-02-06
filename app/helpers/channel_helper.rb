Generic.helpers do
  def move(direction, channel, i)
    operator = direction == :next ? :+ : :-

    target = channel.contents[i.send(operator, 1)]

    # If target doesnt exist then loop back around
    # 
    target.nil? ? channel.contents[0].id : target.id
  end

  def current(channel, id)
    "#{channel.slug}_#{id}"
  end
end
