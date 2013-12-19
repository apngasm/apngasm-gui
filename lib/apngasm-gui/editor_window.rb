require_relative '../apngasm-gui.rb'
require_relative 'frame_list.rb'
require_relative 'frame.rb'
require_relative 'adapter.rb'

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

    @frame_hbox = Gtk::Box.new(:horizontal)
    @frame_list = APNGAsmGUI::FrameList.new(@frame_hbox)

    @scrolled_window = @builder['frame_list_scrolled_window']
    @scrolled_window.add_with_viewport(@frame_hbox)

    @first_button = @builder['first_button']
    @first_button.signal_connect('clicked') do
      if @frame_list.size > 1
        @frame_list.swap(@frame_list.cur, 0)
        $preview.set_pixbuf(@frame_list.pixbuf(0))
        @frame_list.cur = 0
        view_reload
      end
    end

    @back_button = @builder['back_button']
    @back_button.signal_connect('clicked') do
      if @frame_list.cur != 0
        @frame_list.swap(@frame_list.cur, @frame_list.cur - 1)
        @frame_list.cur -= 1
        $preview.set_pixbuf(@frame_list.pixbuf(@frame_list.cur))
        view_reload
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
        view_reload
      end
    end

    @last_button = @builder['last_button']
    @last_button.signal_connect('clicked') do
      if @frame_list.size > 1
        @frame_list.swap(@frame_list.cur, @frame_list.size - 1)
        @frame_list.cur = @frame_list.size - 1
        $preview.set_pixbuf(@frame_list.pixbuf(@frame_list.cur))
        view_reload
      end
    end

    @add_frame_button = @builder['add_frame_button']
    @add_frame_button.signal_connect('clicked') do
      add_dialog
    end

    @import_button = @builder['file_chooser']
    @import_button.add_filter(create_filter)
    @import_button.signal_connect('file_set') do |response|
      file_import(File.expand_path(response.filename))
    end

    @export_button = @builder['export_button']
    @export_button.signal_connect('clicked') do
      export_dialog if @frame_list.size > 0
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

  def add_dialog
    dialog = create_dialog('Open File', Gtk::FileChooser::Action::OPEN, Gtk::Stock::OPEN)
    dialog.set_select_multiple(true) 
    dialog.add_filter(create_filter)

    if dialog.run == Gtk::ResponseType::ACCEPT
      dialog.filenames.each do |filename|
        create_frame(File.expand_path(filename))
      end
      @window_base.show_all
    end
    dialog.destroy
  end

  def export_dialog
    dialog = create_dialog('Save File', Gtk::FileChooser::Action::SAVE, Gtk::Stock::SAVE)
    dialog.do_overwrite_confirmation = true

    if dialog.run == Gtk::ResponseType::ACCEPT
      file_export(File.expand_path(dialog.filename))
    end
    dialog.destroy
  end

  def create_dialog(title, action, stock)
    Gtk::FileChooserDialog.new(title: title,
                               parent: @window_base,
                               action: action,
                               buttons: [[Gtk::Stock::CANCEL, Gtk::ResponseType::CANCEL],
                                        [stock, Gtk::ResponseType::ACCEPT]])
  end

  def create_filter
    filter = Gtk::FileFilter.new
    filter.name = 'PNG File'
    filter.add_pattern('*.png')
    filter
  end

  def create_frame(filename)
    frame = APNGAsmGUI::Frame.new(filename, @frame_list)
    @frame_list << frame
    $preview.set_pixbuf(frame.pixbuf)
    @frame_list.frame_hbox.pack_start(frame, expand: false, fill: false, padding: 10)
  end

  def view_reload
    @frame_list.view_reload
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
    @adapter = APNGAsmGUI::Adapter.new
    @adapter.import(@frame_list, filename)
  end

  def file_export(filename)
    @adapter = APNGAsmGUI::Adapter.new
    @adapter.export(@frame_list, filename)
  end
end
