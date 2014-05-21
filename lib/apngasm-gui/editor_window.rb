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
      move_to_first
    end

    @back_button = @builder['back_button']
    @back_button.signal_connect('clicked') do
      move_to_prev
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
      move_to_next
    end

    @last_button = @builder['last_button']
    @last_button.signal_connect('clicked') do
      move_to_last
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
      @play_loop.set_active(@loop_status)
    end

    @frames_checkbutton = @builder['frames_checkbutton']
    @frames_checkbutton.signal_connect('toggled') do
      @frames_status = @frames_checkbutton.active?
    end

    @file_new = @builder['menu_file_new']
    @file_new.signal_connect('activate') do
      label = Gtk::Label.new('New File?')
      label.show
      dialog = create_confirm_dialog(label, "new")
      dialog.destroy
    end

    @file_import = @builder['menu_file_import']
    @file_import.signal_connect('activate') do
      import_dialog
    end

    @file_export = @builder['menu_file_export']
    @file_export.signal_connect('activate') do
      export_dialog if @frame_list.size > 0
    end

    @file_export_frames = @builder['menu_file_export_frames']
    @file_export_frames.signal_connect('activate') do
      @frames_checkbutton.set_active(true)
      @frames_status = true
      export_dialog if @frame_list.size > 0
    end

    @file_quit = @builder['menu_file_quit']
    @file_quit.signal_connect('activate') do
      label = Gtk::Label.new('Quit?')
      label.show
      dialog = create_confirm_dialog(label, "quit")
      dialog.destroy
    end

    @frame_add = @builder['menu_frame_add']
    @frame_add.signal_connect('activate') do
      add_dialog
    end

    @frame_next = @builder['menu_frame_next']
    @frame_next.signal_connect('activate') do
      move_to_next
    end

    @frame_prev = @builder['menu_frame_prev']
    @frame_prev.signal_connect('activate') do
      move_to_prev
    end

    @frame_last = @builder['menu_frame_last']
    @frame_last.signal_connect('activate') do
      move_to_last
    end

    @frame_first = @builder['menu_frame_first']
    @frame_first.signal_connect('activate') do
      move_to_first
    end

    @frame_delete = @builder['menu_frame_delete']
    @frame_delete.signal_connect('activate') do
      if @frame_list.size > 1
        @frame_list.delete_at(@frame_list.cur)
      end
    end

    @play_play = @builder['menu_play_play']
    @play_play.signal_connect('activate') do
      if @frame_list.size > 1 && !@play
        play_animation
      end
    end

    @play_stop = @builder['menu_play_stop']
    @play_stop.signal_connect('activate') do
      stop_animation if @play
    end

    @play_loop = @builder['menu_play_loop']
    @play_loop.set_active(@loop_status)
    @play_loop.signal_connect('toggled') do
      @loop_status = @play_loop.active?
      @loop_checkbutton.set_active(@loop_status)
    end

    @help_about = @builder['menu_help_about']
    @help_about.signal_connect('activate') do
      help_dialog
    end

    @window_base.signal_connect('destroy') do
      Gtk.main_quit
    end

    @window_base.show_all
    Gtk.main
  end

  def move_to_next
    if @frame_list.cur < @frame_list.size - 1
      swap_frame(@frame_list.cur, @frame_list.cur + 1)
    end
  end

  def move_to_prev
    if @frame_list.cur != 0
      swap_frame(@frame_list.cur, @frame_list.cur - 1)
    end
  end

  def move_to_last
    if @frame_list.size > 1
      swap_frame(@frame_list.cur, @frame_list.size - 1)
    end
  end

  def move_to_first
    if @frame_list.size > 1
      swap_frame(@frame_list.cur, 0)
    end
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

  def import_dialog
    dialog = create_dialog('Import File', Gtk::FileChooser::Action::OPEN, Gtk::Stock::OPEN)
    dialog.add_filter(create_filter)

    if dialog.run == Gtk::ResponseType::ACCEPT
      file_import(File.expand_path(dialog.filename))
      @import_button.filename = dialog.filename
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

  def help_dialog
    # TODO dialog message
    dialog = Gtk::MessageDialog.new(message: 'apngasm-gui is a software to create an APNG file.',
                             parent: @window_base)
    dialog.run
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

  def create_confirm_dialog(title, mode)
    dialog = Gtk::Dialog.new
    dialog.child.pack_start(title, expand: true, fill: true, padding: 30)
    dialog.add_buttons(['Yes', Gtk::ResponseType::YES], ['No', Gtk::ResponseType::NO])

    if dialog.run == Gtk::ResponseType::YES
      @import_button.filename = 'blank'
      @frame_list.delete_all if mode == 'new'
      Gtk.main_quit if mode == 'quit'
    end

    dialog
  end

  def create_frame(filename)
    frame = APNGAsmGUI::Frame.new(filename, @frame_list)
    @frame_list << frame
    $preview.set_pixbuf(frame.pixbuf)
    @frame_list.frame_hbox.pack_start(frame, expand: false, fill: false, padding: 10)
  end

  def swap_frame(old_position, new_position)
    @frame_list.swap(old_position, new_position)
    @frame_list.cur = new_position
    $preview.set_pixbuf(@frame_list.pixbuf(@frame_list.cur))
    view_reload
  end

  def view_reload
    @frame_list.view_reload
    @window_base.show_all
  end

  def play_animation
    @play = true
    image = Gtk::Image.new(stock: Gtk::Stock::MEDIA_STOP, size: Gtk::IconSize::IconSize::BUTTON)
    @play_button.set_image(image)

    @frame_list.cur = 0
    @handle = GLib::Idle.add {
      unless @loop_status
        stop_animation if @frame_list.cur == @frame_list.size - 1
      end

      $preview.set_pixbuf(@frame_list.pixbuf(@frame_list.cur))
      @frame_list.cur - 1 < 0 ? delay_num = @frame_list.size - 1 : delay_num = @frame_list.cur - 1
      sleep(@frame_list.delay(delay_num) * 0.001)
      @frame_list.cur + 1 >= @frame_list.size ? @frame_list.cur = 0 : @frame_list.cur += 1
    }
  end

  def stop_animation
    GLib::Source.remove(@handle)

    @play = false
    image = Gtk::Image.new(stock: Gtk::Stock::MEDIA_PLAY, size: Gtk::IconSize::IconSize::BUTTON)
    @play_button.set_image(image)
  end

  def file_import(filename)
    adapter = APNGAsmGUI::Adapter.new
    new_frames = adapter.import(@frame_list, filename)

    new_frames.each do |frame|
      @frame_list << frame
      @frame_list.frame_hbox.pack_start(frame, expand: false, fill: false, padding: 10)
    end

    $preview.set_pixbuf(@frame_list.pixbuf(@frame_list.cur)) if @frame_list.size > 0
    @window_base.show_all
  end

  def file_export(filename)
    adapter = APNGAsmGUI::Adapter.new
    adapter.export(@frame_list, filename, @frames_status)
  end
end
