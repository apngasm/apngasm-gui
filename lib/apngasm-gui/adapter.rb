require 'rapngasm'
require_relative 'frame_list.rb'
require_relative 'frame.rb'

class APNGAsmGUI::Adapter
  def initialize
    @apngasm = APNGAsm.new
  end

  def import(frame_list, filename)
    @frame_list = frame_list
    frames = @apngasm.disassemble(File.expand_path(filename))
  end

  def export(frame_list, filename)
    @frame_list = frame_list
    @frame_list.list.each do |frame|
      @apngasm.add_frame_from_file(File.expand_path(frame.filename), frame.delay)
    end
    @apngasm.assemble(File.expand_path(filename))
  end
end