$:.unshift "lib"

require "i18n_yaml_editor"
require "i18n_yaml_editor/web"
require "rack/file"

#IYE.startup("test/assets/full_startup_locales")
IYE.startup("locales")

use Rack::Static, :urls => ["/static"]
run I18nYamlEditor::Web
