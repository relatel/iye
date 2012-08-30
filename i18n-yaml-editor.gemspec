Gem::Specification.new do |s|
  s.name     = "i18n-yaml-editor"
  s.version  = "0.9"
  s.date     = "2012-08-30"
  s.summary  = "I18n Yaml Editor"
  s.email    = "hv@firmafon.dk"
  s.homepage = "http://github.com/firmafon/i18n-yaml-editor"
  s.description = "I18n Yaml Editor"
  s.authors  = ["Harry Vangberg"]
  s.executables << "iye"
  s.files    = [
    "README.md",
    "Rakefile",
		"i18n-yaml-editor.gemspec",
    "bin/iye",
		"lib/i18n_yaml_editor.rb",
		"lib/i18n_yaml_editor/app.rb",
		"lib/i18n_yaml_editor/key.rb",
		"lib/i18n_yaml_editor/store.rb",
		"lib/i18n_yaml_editor/transformation.rb",
		"lib/i18n_yaml_editor/web.rb",
    "views/index.html.erb",
    "views/layout.erb",
    "views/translations.html.erb"
  ]
  s.test_files = [
    "test/test_helper.rb",
    "test/unit/test_app.rb",
    "test/unit/test_key.rb",
    "test/unit/test_store.rb",
    "test/unit/test_transformation.rb"
  ]
  s.add_dependency "cuba", "3.1.0"
  s.add_dependency "cuba-contrib", "3.1.0"
  s.add_dependency "tilt", "1.3.3"
end
