require 'gtk3'

class APNGAsmGUI::Frame
  attr_accessor :filename, :position, :pixbuf

  def initialize(image)
#    super()
#    set_size_request(150, 150)
#
#    @pixbuf = Gdk::Pixbuf.new(filename)
#    resize if @pixbuf.width > 150 || @pixbuf.height > 150
#
#    @filename = filename
#    @position = position
#    @click = false
#    @image = Gtk::Image.new(@pixbuf)
#
#    # TODO ノーマル画像とプッシュした時の画像
#
#    add(@image)
#
#    signal_connect('clicked') {
#      p self.filename
#      p self.position
#      # change_image
#    }
  end

  def resize()
#    if (@pixbuf.width >= @pixbuf.height)
#      scale = @pixbuf.height.to_f / @pixbuf.width.to_f
#      @pixbuf = @pixbuf.scale(150, 150 * scale, Gdk::Pixbuf::INTERP_BILINEAR)
#    elsif
#      scale = @pixbuf.width.to_f / @pixbuf.height.to_f
#      @pixbuf = @pixbuf.scale(150 * scale, 150, Gdk::Pixbuf::INTERP_BILINEAR)
#    end
  end

  def change_image
#    remove(@image)
#
#    if @click
#      @click = false
#      # TODO 画像変更
#      #@image = 
#    else
#      @click = true
#      # TODO 画像変更
#      #@image = 
#    end
#
#    add(@image)
#    $window_base.show_all
  end

end
