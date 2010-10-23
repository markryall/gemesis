Gem::Specification.new do |s|
  s.name = 'gemesis'
  s.version = '0.0.5'
  s.summary = 'some lightweight utilities to assist in managing a rubygem'
  s.authors << 'Mark Ryall'
  s.email = 'mark@ryall.name'
  s.homepage = %q{http://github.com/markryall/gemesis}
  s.files = Dir['bin/*'] + Dir['lib/**/*'] + ['README.rdoc', 'MIT-LICENSE']
  s.executables << 'collect_gems'
end
