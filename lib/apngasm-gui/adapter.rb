require 'rapngasm'
require 'fileutils'
require_relative 'frame_list.rb'
require_relative 'frame.rb'
# require_relative 'rapngasm.bundle'

class APNGAsmGUI::Adapter
  def initialize
    @apngasm = APNGAsm.new
  end

  def import(frame_list, filename)
    apngframes = @apngasm.disassemble(filename)
    filename = set_filename(filename)
    apngframes.each_with_index do |apngframe, i|
      # frame_list << APNGAsmGUI::Frame.new("#{filename}_#{i}.png", frame_list, apngframe)
    end
    frame_list
  end

  def export(frame_list, filename, frames_status)
    filename = set_filename(filename)

    frame_list.list.each do |frame|
      @apngasm.add_frame(set_apngframe(frame))
    end
    @apngasm.assemble("#{filename}.png")

    if frames_status
      # @apngasm.reset

      # @apngasm.disassemble("#{filename}.png")
      # FileUtils.mkdir_p(filename) unless File.exist?(filename)
      # @apngasm.save_pngs(filename)
      # @apngasm.save_json("#{filename}/animation.json", filename)
    end
  end

  def set_apngframe(frame)
    frame.apngframe.delay_numerator(frame.delay)
    frame.apngframe
    # new_frame = APNGFrame.new(frame.filename)
    # new_frame.delay_numerator(frame.delay)
    # new_frame
  end

  def set_filename(filename)
    dirname = File.dirname(filename)
    basename = File.basename(filename, '.png')
    new_filename = "#{dirname}/#{basename}"
  end
end