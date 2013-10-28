Gem::Specification.new do |s|
  s.name        = 'apngasm-gui'
  s.version     = '0.0.1'
  s.license     = 'libpng/zlib'
  s.summary     = ""
  s.description = ""
  s.authors     = ['Rika Yoshida', 'Rei Kagetsuki']
  s.email       = 'info@genshin.org'
  s.files        = `git ls-files`.split("\n")
  s.homepage    = 'http://emojidex.com/dev'

  s.executables << 'apngasm-gui'

  s.add_dependency 'rapngasm'
  s.add_dependency 'gtk3'
end
