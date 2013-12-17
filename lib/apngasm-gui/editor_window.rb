require_relative '../apngasm-gui.rb'
require_relative 'frame_list.rb'
require_relative 'frame.rb'

class APNGAsmGUI::EditorWindow
  def initialize(width = 800, height = 600)
    @builder = Gtk::Builder.new
    @builder.add_from_file(File.expand_path('../layout.glade', __FILE__))


    $window_base = @builder["editor_window"]
    $window_base.set_default_size(width, height)

    @preview = @builder["preview_image"]

    @frame_list = APNGAsmGUI::FrameList.new(@builder["frame_list_scrolled_window"])

    @frame_hbox = Gtk::Box.new(:horizontal)
    @frame_list.scrolled_window.add_with_viewport(@frame_hbox)

    @add_frame_button = @builder["add_frame_button"]
    @add_frame_button.signal_connect('clicked') {
      dialog = Gtk::FileChooserDialog.new(title: "Open File",
                                          parent: $window_base,
                                          action: Gtk::FileChooser::Action::OPEN,
                                          buttons: [[Gtk::Stock::CANCEL, Gtk::ResponseType::CANCEL],
                                                   [Gtk::Stock::OPEN, Gtk::ResponseType::ACCEPT]])
      filter = Gtk::FileFilter.new
      filter.name = "Img File"
      filter.add_pattern("*.png")
      dialog.add_filter(filter)
      if dialog.run == Gtk::ResponseType::ACCEPT
        # Get file
        frame = create_frame(dialog.filename)

        @frame_hbox.pack_start(frame, expand: false, fill: false, padding: 10)
        $window_base.show_all
      end
      dialog.destroy
    }

    $window_base.signal_connect("destroy") do
      Gtk.main_quit
    end

    $window_base.show_all
    Gtk.main
  end

  def create_frame(filename)
    frame = Gtk::Frame.new
    img = Gtk::Image.new(filename)
    @preview.set_pixbuf img.pixbuf
    box = Gtk::Box.new(:vertical)
    box.pack_start(img, expand: false, fill: false, padding: 10)
    adjustment = Gtk::Adjustment.new(10, 1, 999, 1, 1, 0)
    delay_spinner = Gtk::SpinButton.new(adjustment, 1, 0)
    delete_button = Gtk::Button.new(label: 'Delete')
    box.pack_start(delay_spinner, expand: false, fill: false)
    box.pack_start(delete_button, expand: false, fill: false)
    frame.add(box)

    return frame
  end 
end
