class FrameList

  def initialize
    @list = Array.new
  end

  def add(data)
    @list << data
  end

  def get_filename(position)
    return nil if position > @list.size
    return @list[position].filename
  end

  def get_pixbuf(position)
    return nil if position > @list.size
    return @list[position].pixbuf
  end

  def position_change(old_position, new_position)
    @list[old_position], @list[new_position] = @list[new_position], @list[old_position]
  end

end
