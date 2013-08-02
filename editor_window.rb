require 'rubygems'
gem 'gtk3'

require './frame_list.rb'
require './frame.rb'

class EditorWindow
  def initialize(width = 800, height = 600)
    @builder = Gtk::Builder.new
    @builder.add_from_file("layout.glade")


    $window_base = @builder["editor_window"]
    $window_base.set_default_size(width, height)

    @preview = @builder["preview_image"]

    @frame_list = FrameList.new(@builder["frame_list_scrolled_window"])

    @frame_hbox = Gtk::HBox.new
    @frame_list.scrolled_window.add_with_viewport(@frame_hbox)

    @add_frame_button = @builder["add_frame_button"]
    @add_frame_button.signal_connect('clicked') {
      dialog = Gtk::FileChooserDialog.new("Open File",
                                          $window_base,
                                          Gtk::FileChooser::ACTION_OPEN,
                                          nil,
                                          [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_CANCEL],
                                          [Gtk::Stock::OPEN, Gtk::Dialog::RESPONSE_ACCEPT])
      filter = Gtk::FileFilter.new
      filter.name = "Img File"
      filter.add_pattern("*.png")
      dialog.add_filter(filter)
      if dialog.run == Gtk::Dialog::RESPONSE_ACCEPT
        # Get file
        frame = create_frame(dialog.filename)

        @frame_hbox.pack_start(frame, false, false, 10)
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
    box = Gtk::VBox.new
    box.pack_start(img, false, false, 10)
    adjustment = Gtk::Adjustment.new(10, 1, 999, 1, 1, 0)
    delay_spinner = Gtk::SpinButton.new(adjustment, 1, 0)
    delete_button = Gtk::Button.new('Delete')
    box.pack_start(delay_spinner, false, false, 0)
    box.pack_start(delete_button, false, false, 0)
    frame.add(box)

    return frame
  end 
end
