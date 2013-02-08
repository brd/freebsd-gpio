Gem::Specification.new do |s|
  s.name        = 'gpio'
  s.version     = '0.0.1'
  s.date        = '2013-02-07'
  s.summary     = "Access to GPIO on FreeBSD"
  s.description = "Ruby wrapper for accessing GPIO on FreeBSD"
  s.authors     = ["Oleksandr Tymoshenko"]
  s.email       = 'gonzo@bluezbox.com'
  s.files       = Dir.glob('lib/**/*.rb') +
	          Dir.glob('ext/**/*.{c,h,rb}');
  s.extensions  = ["ext/bsdgpio/extconf.rb"]
  s.homepage    = 'https://github.com/gonzoua/freebsd-gpio'
end
