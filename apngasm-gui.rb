#!/usr/bin/env ruby

#apngasm GUI by Genshin Souzou Kabushiki Kaisha
#licensed under the GNU GPL v3


require './editor_window.rb'

class APNGAsmGUI
  TITLE = 'apngasm GUI'
  NAME = 'apngasm-gui'
  VERSION = '0.0.1-mockup'

  def initialize(width = 800, height = 600, file = nil)
    @editor_window = EditorWindow.new(width, height)
  end
end

APNGAsmGUI.new
