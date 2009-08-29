spec = Gem::Specification.new do |s|
  s.name = 'swing4rb'
  s.version = '0.2'
  s.summary = "Declarative style Swing GUI API."
  s.description = "Declarative style Swing GUI API."
  s.files = Dir['*.rb'] + Dir['README.txt']
  s.require_path = './'
  s.autorequire = 'swing4rb'
  s.has_rdoc = true
  s.rdoc_options << '--title' <<  'swing4rb -- Declarative style Swing GUI API.'
  s.author = "Toby Ho"
  s.email = "airportyh@gmail.com"
end