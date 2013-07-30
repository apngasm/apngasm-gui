require 'rubygems'
gem 'gtk3'

require './frame_list.rb'
require './frame.rb'

class EditorWindow
  #attr_accessor preview, frame_list
  def initialize(width = 800, height = 600)
    builder = Gtk::Builder.new
    builder.add_from_file("layout.glade")


    $window_base = builder["editor_window"]
    $window_base.set_default_size(width, height)

    @preview = builder["preview_image"]

    @frame_list = FrameList.new

    @add_frame_button = builder["add_frame_button"]
#    @add_frame_button.signal_connect('file-set') {
#      frame = Frame.new(@add_frame_button.filename)
#      
#      @frame_list.add(frame)
#      @preview.set_pixbuf(frame.pixbuf)

#      $window_base.show_all
#    }

    $window_base.signal_connect("destroy") do
      Gtk.main_quit
    end

    $window_base.show_all
    Gtk.main
  end
end
