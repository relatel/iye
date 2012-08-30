require "rack/file"

require "i18n_yaml_editor/web_editor"

module I18nYamlEditor
  Web = Rack::Builder.new do
    use Rack::ShowExceptions
    use Rack::Static, :urls => ["/static"]
    run I18nYamlEditor::WebEditor
  end
end
