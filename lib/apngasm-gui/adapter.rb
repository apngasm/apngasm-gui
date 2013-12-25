require 'rapngasm'
require 'fileutils'
require_relative 'frame_list.rb'
require_relative 'frame.rb'

class APNGAsmGUI::Adapter
  def import(frame_list, filename)
    apngasm = APNGAsm.new
    apngframes = apngasm.disassemble(filename)
    filename = set_filename(filename)
    apngframes.each_with_index do |apngframe, i|
      # TODO
      # frame = APNGAsmGUI::Frame.new("#{filename}_#{i}.png", @frame_list, apngframe)
      # frame_list << frame
    end
    frame_list
  end

  def export(frame_list, filename, frames_status)
    filename = set_filename(filename)

    apngasm = APNGAsm.new
    frame_list.list.each do |frame|
      apngasm.add_frame(set_apngframe(frame))
    end
    apngasm.assemble("#{filename}.png")

    if frames_status
      frame_list.list.each_with_index do |frame, i|
        apngasm = APNGAsm.new
        apngasm.add_frame(set_apngframe(frame))
        FileUtils.mkdir_p(filename) unless File.exist?(filename)
        apngasm.assemble("#{filename}/#{i}.png")
        # TODO
        # export json animation file 
      end
    end
  end

  def set_apngframe(frame)
    frame.apngframe.delay_numerator(frame.delay)
    frame.apngframe
  end

  def set_filename(filename)
    dirname = File.dirname(filename)
    basename = File.basename(filename, '.png')
    new_filename = "#{dirname}/#{basename}"
  end
end