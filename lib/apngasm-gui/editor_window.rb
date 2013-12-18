require_relative '../apngasm-gui.rb'
require_relative 'frame_list.rb'
require_relative 'frame.rb'
require_relative '../rapngasm'

class APNGAsmGUI::EditorWindow
  def initialize(width = 800, height = 600)
    @preview_images = []
    @preview_position = 0
    @play = false

    @builder = Gtk::Builder.new
    @builder.add_from_file(File.expand_path('../layout.glade', __FILE__))

    $window_base = @builder['editor_window']
    $window_base.set_default_size(width, height)

    @preview = @builder['preview_image']

    @frame_list = APNGAsmGUI::FrameList.new(@builder['frame_list_scrolled_window'])

    @frame_hbox = Gtk::Box.new(:horizontal)
    @frame_list.scrolled_window.add_with_viewport(@frame_hbox)

    @first_button = @builder['first_button']
    @first_button.signal_connect('clicked') {
      if @preview_images.length > 1
        @preview.set_pixbuf(@preview_images[0])
        @preview_position = 0
      end
    }

    @back_button = @builder['back_button']
    @back_button.signal_connect('clicked') {
      if @preview_images.length > 1 && @preview_position != 0
        @preview_position -= 1
        @preview.set_pixbuf(@preview_images[@preview_position])
      end
    }

    @play_button = @builder['play_button']
    @play_button.signal_connect('clicked') {
      if @play
        stop_animation
      elsif @preview_images.length > 1
        play_animation
      end
    }

    @forward_button = @builder['forward_button']
    @forward_button.signal_connect('clicked') {
      if @preview_images.length > 1 && @preview_position != @preview_images.length - 1
        @preview_position += 1
        @preview.set_pixbuf(@preview_images[@preview_position])
      end
    }

    @last_button = @builder['last_button']
    @last_button.signal_connect('clicked') {
      if @preview_images.length > 1
        @preview_position = @preview_images.length - 1
        @preview.set_pixbuf(@preview_images[@preview_position])
      end
    }

    @add_frame_button = @builder['add_frame_button']
    @add_frame_button.signal_connect('clicked') {
      dialog = Gtk::FileChooserDialog.new(title: 'Open File',
                                          parent: $window_base,
                                          action: Gtk::FileChooser::Action::OPEN,
                                          buttons: [[Gtk::Stock::CANCEL, Gtk::ResponseType::CANCEL],
                                                   [Gtk::Stock::OPEN, Gtk::ResponseType::ACCEPT]])
      filter = Gtk::FileFilter.new
      filter.name = 'Img File'
      filter.add_pattern('*.png')
      dialog.add_filter(filter)
      if dialog.run == Gtk::ResponseType::ACCEPT
        # Get file
        frame = create_frame(dialog.filename)

        @frame_hbox.pack_start(frame, expand: false, fill: false, padding: 10)
        $window_base.show_all
      end
      dialog.destroy
    }

    $window_base.signal_connect('destroy') do
      Gtk.main_quit
    end

    $window_base.show_all
    Gtk.main
  end

  def create_frame(filename)
    frame = APNGAsmGUI::Frame.new(filename, @frame_hbox)
    @preview.set_pixbuf(frame.pixbuf)
    @preview_images << frame.pixbuf
    @preview_position = @preview_images.length - 1
    frame
  end

  def create_apng_frame(filename, delay = 100)
  end

  def play_animation
    @play = true
    image = Gtk::Image.new(stock: Gtk::Stock::MEDIA_STOP, size: Gtk::IconSize::IconSize::BUTTON)
    @play_button.set_image(image)
  end

  def stop_animation
    @play = false
    image = Gtk::Image.new(stock: Gtk::Stock::MEDIA_PLAY, size: Gtk::IconSize::IconSize::BUTTON)
    @play_button.set_image(image)
  end
end
