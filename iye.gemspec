Gem::Specification.new do |s|
  s.name     = "iye"
  s.version  = "1.1.1"
  s.date     = "2015-04-17"
  s.summary  = "I18n Yaml Editor"
  s.email    = "hv@firmafon.dk"
  s.homepage = "http://github.com/firmafon/iye"
  s.description = "I18n YAML Editor"
  s.authors  = ["Harry Vangberg"]
  s.executables << "iye"
  s.files    = [
    "README.md",
    "Rakefile",
		"iye.gemspec",
    "bin/iye",
		"lib/i18n_yaml_editor.rb",
		"lib/i18n_yaml_editor/app.rb",
		"lib/i18n_yaml_editor/category.rb",
		"lib/i18n_yaml_editor/key.rb",
		"lib/i18n_yaml_editor/store.rb",
		"lib/i18n_yaml_editor/transformation.rb",
		"lib/i18n_yaml_editor/translation.rb",
		"lib/i18n_yaml_editor/web.rb",
    "views/layout.erb",
    "views/categories.html.erb",
    "views/translations.html.erb",
    "views/new.html.erb"
  ]
  s.test_files = [
    "test/test_helper.rb",
    "test/unit/test_app.rb",
    "test/unit/test_category.rb",
    "test/unit/test_key.rb",
    "test/unit/test_store.rb",
    "test/unit/test_transformation.rb",
    "test/unit/test_translation.rb"
  ]
  s.add_dependency "cuba", ">= 3"
  s.add_dependency "tilt", ">= 1.3"
  s.add_dependency "psych", ">= 1.3.4"
end
