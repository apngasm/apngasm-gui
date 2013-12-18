require 'gtk3'

class APNGAsmGUI::FrameList
  attr_accessor :scrolled_window, :cur

  def initialize(scrolled_window)
    @scrolled_window = scrolled_window
    @list = []
  end

  def <<(data)
    @list << data
    @cur = @list.size - 1
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

  def size
    @list.size
  end

  def first
    @cur = 0
  end

  def back
    @cur -= 1
  end

  def forward
    @cur += 1
  end

  def last
    @cur = @list.size - 1
  end
end
