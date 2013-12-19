require 'rapngasm'
require_relative 'frame_list.rb'
require_relative 'frame.rb'

class APNGAsmGUI::Adapter
  def initialize
    @apngasm = APNGAsm.new
  end

  def import(frame_list, filename)
    apngframes = @apngasm.disassemble(filename)
    base_filename = filename[0, filename.length - 4]
    apngframes.each_with_index do |apngframe, i|
      # frame = APNGAsmGUI::Frame.new("#{base_filename}#{i}.png", @frame_list, apngframe)
      # frame_list << frame
    end
    frame_list
  end

  def export(frame_list, filename)
    frame_list.list.each do |frame|
      frame.apngframe.delay_numerator(frame.delay)
      @apngasm.add_frame(frame.apngframe)
    end
    @apngasm.assemble(filename)
  end
end