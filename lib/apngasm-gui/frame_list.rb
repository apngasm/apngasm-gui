require 'gtk3'

class APNGAsmGUI::FrameList
  attr_accessor :scrolled_window, :list, :cur

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
    case new_position
    when 0 then
      tmp = @list[old_position]
      @list.delete_at(old_position)
      @list.insert(0, tmp)
    when @list.size - 1 then
      tmp = @list[old_position]
      @list.delete_at(old_position)
      @list << tmp
    else
      @list[old_position], @list[new_position] = @list[new_position], @list[old_position]
    end
  end

  def remove(child)
    @list.delete(child)
    @cur -= 1 unless @cur == 0
    if @list.size == 0
      $preview.set_stock(Gtk::Stock::MISSING_IMAGE)
    else
      $preview.set_pixbuf(@list[@cur].pixbuf)
    end
  end

  def focus(child)
    @cur = @list.find_index(child)
    $preview.set_pixbuf(@list[@cur].pixbuf)
  end

  def size
    @list.size
  end
end
