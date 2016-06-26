Gem::Specification.new do |s|
  s.name        = 'apngasm-gui'
  s.version     = '0.0.1'
  s.license     = 'GNU GPL v3'
  s.summary     = ""
  s.description = ""
  s.authors     = ['Rika Yoshida', 'Rei Kagetsuki']
  s.email       = 'info@genshin.org'
  s.files        = `git ls-files`.split("\n")
  s.homepage    = 'https://github.com/apngasm/apngasm-gui'

  s.executables << 'apngasm-gui'

  s.add_dependency 'rapngasm', '~> 3.2', '3.2.0'
  s.add_dependency 'gtk3'
end
