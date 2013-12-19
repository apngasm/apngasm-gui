require 'gtk3'

class APNGAsmGUI::Frame < Gtk::Frame
  THUMBNAIL_SIZE = 100
  attr_accessor :filename, :pixbuf

  def initialize(filename, parent_list, parent_frame)
    super()
    @filename = filename
    @parent_list = parent_list
    @parent_frame = parent_frame

    image = Gtk::Image.new(file: filename)
    @pixbuf = image.pixbuf
    if image.pixbuf.width > THUMBNAIL_SIZE || image.pixbuf.height > THUMBNAIL_SIZE
      image.pixbuf = resize(image.pixbuf, THUMBNAIL_SIZE)
    end

    image_button = Gtk::Button.new
    image_button.set_relief(Gtk::ReliefStyle::NONE)
    button_box = Gtk::Box.new(:vertical)
    button_box.pack_start(image)
    image_button.add(button_box)
    image_button.signal_connect('clicked') do
      @parent_list.focus(self)
    end

    box = Gtk::Box.new(:vertical)
    box.pack_start(image_button, expand: true, fill: false, padding: 10)

    adjustment = Gtk::Adjustment.new(100, 1, 999, 1, 1, 0)
    @delay_spinner = Gtk::SpinButton.new(adjustment, 1, 0)
    box.pack_start(@delay_spinner, expand: false, fill: false)

    delete_button = Gtk::Button.new(label: 'Delete')
    delete_button.signal_connect('clicked') {
      @parent_list.remove(self)
      @parent_frame.remove(self)
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
