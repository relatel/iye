Gem::Specification.new do |s|
  s.name     = 'translator'
  s.version  = '1.1.1'
  s.date     = '2015-09-30'
  s.summary  = 'I18n Yaml Editor'
  s.email    = 'wolfgang.teuber@sage.com'
  s.homepage = 'http://github.com/Sage/translator'
  s.description = 'I18n YAML Editor'
  s.authors  = ['Harry Vangberg', 'Wolfgang Teuber']
  s.executables << 'translator'
  s.files    = [
    'README.md',
    'Rakefile',
    'translator.gemspec',
    'bin/translator',
    'lib/i18n_yaml_editor.rb',
    'lib/i18n_yaml_editor/app.rb',
    'lib/i18n_yaml_editor/category.rb',
    'lib/i18n_yaml_editor/core_ext.rb',
    'lib/i18n_yaml_editor/key.rb',
    'lib/i18n_yaml_editor/store.rb',
    'lib/i18n_yaml_editor/transformation.rb',
    'lib/i18n_yaml_editor/translation.rb',
    'lib/i18n_yaml_editor/web.rb',
    'views/layout.erb',
    'views/categories.html.erb',
    'views/translations.html.erb'
  ]
  s.test_files = [
    'test/test_helper.rb',
    'test/unit/test_app.rb',
    'test/unit/test_category.rb',
    'test/unit/test_key.rb',
    'test/unit/test_store.rb',
    'test/unit/test_transformation.rb',
    'test/unit/test_translation.rb'
  ]
  s.add_dependency 'activesupport'
  s.add_dependency 'cuba', '>= 3'
  s.add_dependency 'tilt', '>= 1.3'
  s.add_dependency 'psych', '>= 1.3.4'

  s.add_development_dependency 'rake'
end
