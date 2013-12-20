require 'gtk3'

class APNGAsmGUI::FrameList
  attr_accessor :frame_hbox, :cur, :list

  def initialize(frame_hbox)
    @frame_hbox = frame_hbox
    @list = []
  end

  def <<(data)
    @list << data
    @cur = @list.size - 1
  end

  def size
    @list.size
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
      @list.insert(0, @list[old_position])
      @list.delete_at(old_position + 1)
    when @list.size - 1 then
      @list << @list[old_position]
      @list.delete_at(old_position)
    else
      @list[old_position], @list[new_position] = @list[new_position], @list[old_position]
    end
  end

  def delete(child)
    @list.delete(child)
    @frame_hbox.remove(child)
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

  def view_reload
    @list.each { |frame| @frame_hbox.remove(frame) }
    @list.each do |frame|
      @frame_hbox.pack_start(frame, expand: false, fill: false, padding: 10)
    end
  end
end
