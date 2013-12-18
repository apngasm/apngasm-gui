require_relative '../apngasm-gui.rb'
require_relative 'frame_list.rb'
require_relative 'frame.rb'
require 'rapngasm'

class APNGAsmGUI::EditorWindow
  def initialize(width = 800, height = 600)
    @play = false
    @loop_status = false
    @frames_status = false

    @builder = Gtk::Builder.new
    @builder.add_from_file(File.expand_path('../layout.glade', __FILE__))

    @window_base = @builder['editor_window']
    @window_base.set_default_size(width, height)

    $preview = @builder['preview_image']

    @frame_list = APNGAsmGUI::FrameList.new(@builder['frame_list_scrolled_window'])

    @frame_hbox = Gtk::Box.new(:horizontal)
    @frame_list.scrolled_window.add_with_viewport(@frame_hbox)

    @first_button = @builder['first_button']
    @first_button.signal_connect('clicked') do
      if @frame_list.size > 1
        @frame_list.swap(@frame_list.cur, 0)
        $preview.set_pixbuf(@frame_list.pixbuf(0))
        @frame_list.cur = 0
        frame_hbox_reload
      end
    end

    @back_button = @builder['back_button']
    @back_button.signal_connect('clicked') do
      if @frame_list.cur != 0
        @frame_list.swap(@frame_list.cur, @frame_list.cur - 1)
        @frame_list.cur -= 1
        $preview.set_pixbuf(@frame_list.pixbuf(@frame_list.cur))
        frame_hbox_reload
      end
    end

    @play_button = @builder['play_button']
    @play_button.signal_connect('clicked') do
      if @play
        stop_animation
      elsif @frame_list.size > 1
        play_animation
      end
    end

    @forward_button = @builder['forward_button']
    @forward_button.signal_connect('clicked') do
      if @frame_list.cur < @frame_list.size - 1
        @frame_list.swap(@frame_list.cur, @frame_list.cur + 1)
        @frame_list.cur += 1
        $preview.set_pixbuf(@frame_list.pixbuf(@frame_list.cur))
        frame_hbox_reload
      end
    end

    @last_button = @builder['last_button']
    @last_button.signal_connect('clicked') do
      if @frame_list.size > 1
        @frame_list.swap(@frame_list.cur, @frame_list.size - 1)
        @frame_list.cur = @frame_list.size - 1
        $preview.set_pixbuf(@frame_list.pixbuf(@frame_list.cur))
        frame_hbox_reload
      end
    end

    @add_frame_button = @builder['add_frame_button']
    @add_frame_button.signal_connect('clicked') do
      open_dialog
    end

    @import_button = @builder['file_chooser']
    @import_button.signal_connect('file_set') do |response|
      file_import(response.filename)
    end

    @export_button = @builder['export_button']
    @export_button.signal_connect('clicked') do
      file_export if @frame_list.size > 0
    end

    @loop_checkbutton = @builder['loop_checkbutton']
    @loop_checkbutton.signal_connect('toggled') do
      @loop_status = @loop_checkbutton.active?
    end

    @frames_checkbutton = @builder['frames_checkbutton']
    @frames_checkbutton.signal_connect('toggled') do
      @frames_status = @frames_checkbutton.active?
    end

    @window_base.signal_connect('destroy') do
      Gtk.main_quit
    end

    @window_base.show_all
    Gtk.main
  end

  def open_dialog
    dialog = Gtk::FileChooserDialog.new(title: 'Open File',
                                          parent: @window_base,
                                          action: Gtk::FileChooser::Action::OPEN,
                                          buttons: [[Gtk::Stock::CANCEL, Gtk::ResponseType::CANCEL],
                                                   [Gtk::Stock::OPEN, Gtk::ResponseType::ACCEPT]])
    dialog.set_default_size(400, 400)
    dialog.set_select_multiple(true)

    filter = Gtk::FileFilter.new
    filter.name = 'Img File'
    filter.add_pattern('*.png')
    dialog.add_filter(filter)

    if dialog.run == Gtk::ResponseType::ACCEPT
      dialog.filenames.each do |filename|
        create_frame(filename)
      end
      @window_base.show_all
    end
    dialog.destroy
  end

  def create_frame(filename)
    frame = APNGAsmGUI::Frame.new(filename, @frame_list, @frame_hbox)
    @frame_list << frame
    $preview.set_pixbuf(frame.pixbuf)
    @frame_hbox.pack_start(frame, expand: false, fill: false, padding: 10)
  end

  def frame_hbox_reload
    @frame_list.list.each { |frame| @frame_hbox.remove(frame) }
    @frame_list.list.each do |frame|
      @frame_hbox.pack_start(frame, expand: false, fill: false, padding: 10)
    end
    @window_base.show_all
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

  def file_import(filename)
  end

  def file_export
  end

  def create_apng_frame(filename, delay = 100)
  end
end
