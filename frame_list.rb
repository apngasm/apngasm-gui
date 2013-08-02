require 'gtk3'

class FrameList
  attr_accessor :scrolled_window

  def initialize(scrolled_window)
    @scrolled_window = scrolled_window
    @list = Array.new
  end

  def <<(data)
    @list << data
    @cur = @list.size - 1
  end

  def cur
    @cur
  end

  def filename(position = nil)
    return @list[@cur].filename if position.nil?
    return nil if position > @list.size
    return @list[position].filename
  end

  def pixbuf(position = nil)
    return @list[@cur].pixbuf if position.nil?
    return nil if position > @list.size
    return @list[position].pixbuf
  end

  def swap(old_position, new_position)
    @list[old_position], @list[new_position] = @list[new_position], @list[old_position]
  end

end
