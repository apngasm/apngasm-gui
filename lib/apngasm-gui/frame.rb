require 'gtk3'

class APNGAsmGUI::Frame < Gtk::Frame
  PREVIEW_SIZE = 500
  THUMBNAIL_SIZE = 100
  attr_accessor :filename, :position, :pixbuf

  def initialize(filename, parent)
    super()
    @filename = filename
    @parent = parent

    image = Gtk::Image.new(file: filename)
    @pixbuf = image.pixbuf
    if @pixbuf.width > PREVIEW_SIZE || @pixbuf.height > PREVIEW_SIZE
      @pixbuf = resize(@pixbuf, PREVIEW_SIZE)
    end
    if image.pixbuf.width > THUMBNAIL_SIZE || image.pixbuf.height > THUMBNAIL_SIZE
      image.pixbuf = resize(image.pixbuf, THUMBNAIL_SIZE)
    end

    box = Gtk::Box.new(:vertical)
    box.pack_start(image, expand: true, fill: false, padding: 10)

    adjustment = Gtk::Adjustment.new(10, 1, 999, 1, 1, 0)
    @delay_spinner = Gtk::SpinButton.new(adjustment, 1, 0)
    box.pack_start(@delay_spinner, expand: false, fill: false)

    delete_button = Gtk::Button.new(label: 'Delete')
    delete_button.signal_connect('clicked') {
      @parent.remove(self)
    }
    box.pack_start(delete_button, expand: false, fill: false)

    add(box)
  end

#  def initialize(image)
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
#  end

  def resize(pixbuf, size)
   if pixbuf.width >= pixbuf.height
     scale = pixbuf.height.to_f / pixbuf.width.to_f
     pixbuf = pixbuf.scale(size, size * scale, Gdk::Pixbuf::INTERP_BILINEAR)
   else
     scale = pixbuf.width.to_f / pixbuf.height.to_f
     pixbuf = pixbuf.scale(size * scale, size, Gdk::Pixbuf::INTERP_BILINEAR)
   end
   pixbuf
  end

  def delay
    @delay_spinner.value
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
