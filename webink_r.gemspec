Gem::Specification.new do |s|
  s.name = "webink_r"
  s.version = '0.4.0'
  s.summary = "a minimal chainable sql string builder"
  s.author = "Matthias Geier"
  s.homepage = "https://github.com/matthias-geier/webink_r"
  s.licenses = ['BSD-2']
  s.require_path = 'lib'
  s.files = Dir['lib/*.rb'] + Dir['lib/webink/*.rb'] << "LICENSE.md"
  s.required_ruby_version = '>= 1.9.3'
end
