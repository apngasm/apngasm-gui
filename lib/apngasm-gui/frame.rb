require 'gtk3'

class APNGAsmGUI::Frame < Gtk::Frame
  THUMBNAIL_SIZE = 100
  attr_accessor :filename, :pixbuf, :apngframe

  def initialize(filename, parent, apngframe = nil)
    super()
    @generator = APNGFrameGenerator.new
    @filename = filename
    @parent = parent
    @apngframe = apngframe

    if @apngframe.nil?
      @apngframe = @generator.init_with_file(@filename)
      image = Gtk::Image.new(file: @filename)
    else
      # TODO Create image from APNGFrame...
      # tmp_pixels = @apngframe.pixels
      # pixels = []
      # tmp_pixels.each do |pixel|
      #   pixels << "0x#{"%02x" % pixel}"
      # end
      # data = Gdk::Pixdata.deserialize(tmp_pixels)

      pixbuf = Gdk::Pixbuf.new(@apngframe.pixels.to_s, Gdk::Pixbuf::COLORSPACE_RGB, true, 8,
                               @apngframe.width, @apngframe.height, @apngframe.width * 4)
      # pixbuf = Gdk::Pixbuf.new(@apngframe.pixels.to_s)
      
      # pixmap = Cairo::ImageSurface.new(pixels.to_s, Cairo::FORMAT_ARGB32, @apngframe.width, @apngframe.height,
      #   Cairo::Format.stride_for_width(Cairo::FORMAT_ARGB32, @apngframe.width))
      # pixbuf = Gdk::Pixbuf.new(pixels, true)

      # pixbuf = Gdk::Pixbuf.new(Gdk::Pixbuf::COLORSPACE_RGB, true, 8, @apngframe.width, @apngframe.height)
      image = Gtk::Image.new
      image.pixbuf = pixbuf
    end
    if image.pixbuf.width != nil && image.pixbuf.height != nil
      if image.pixbuf.width > THUMBNAIL_SIZE || image.pixbuf.height > THUMBNAIL_SIZE
        image.pixbuf = resize(image.pixbuf, THUMBNAIL_SIZE)
      end
    end
    @pixbuf = image.pixbuf

    image_button = Gtk::Button.new
    image_button.set_relief(Gtk::ReliefStyle::NONE)
    image_button.add(image)
    image_button.signal_connect('clicked') do
      @parent.focus(self)
    end

    box = Gtk::Box.new(:vertical)
    box.pack_start(image_button, expand: true, fill: false, padding: 10)

    adjustment = Gtk::Adjustment.new(100, 1, 999, 1, 1, 0)
    @delay_spinner = Gtk::SpinButton.new(adjustment, 1, 0)
    set_delay(@apngframe.delay_numerator)
    box.pack_start(@delay_spinner, expand: false, fill: false)

    delete_button = Gtk::Button.new(label: 'Delete')
    delete_button.signal_connect('clicked') {
      @parent.delete(self)
    }
    box.pack_start(delete_button, expand: false, fill: false)

    add(box)
  end

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

  def set_delay(value)
    @delay_spinner.set_value(value)
  end
end
