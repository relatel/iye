lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'i18n_yaml_editor/version'

Gem::Specification.new do |s|
  s.name     = "iye"
  s.version  = I18nYamlEditor::VERSION
  s.date     = "2015-04-17"
  s.summary  = "I18n Yaml Editor"
  s.email    = "hv@firmafon.dk"
  s.homepage = "http://github.com/firmafon/iye"
  s.description = "I18n YAML Editor"
  s.authors  = ["Harry Vangberg"]

  s.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.bindir = 'bin'
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency "hobbit", "~> 0.6.0"
  s.add_dependency "hobbit-contrib", "~> 0.7.1"
  s.add_dependency "tilt", ">= 1.3"
  s.add_dependency "psych", ">= 1.3.4"

  s.add_development_dependency 'rake', '>= 10.4.2'
  s.add_development_dependency 'minitest', '>= 5.8.1'
end
