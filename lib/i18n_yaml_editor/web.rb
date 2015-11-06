require 'rack'
require 'hobbit'
require 'hobbit/render'
require 'tilt/erb'

require 'i18n_yaml_editor/app'

module I18nYamlEditor

  ##
  # Web interface to I18nYamlEditor::App
  class Web < Hobbit::Base
    include Hobbit::Render

    use Rack::Static, urls: ['/stylesheets'], root: I18nYamlEditor.root.join('public')
    use Rack::MethodOverride
    use Rack::ShowExceptions

    def views_path
      @views_path ||= I18nYamlEditor.root.join('views')
    end

    def default_layout
      "#{views_path}/layout.#{template_engine}"
    end

    ##
    # applications root path
    # can be different if it is mounted inside another rack app
    #
    # @return [String]
    def root_path
      "#{request.script_name}/"
    end

    ##
    # IYE app context
    #
    # @return [I18nYamlEditor::App]
    def app
      env['iye.app'] || raise('Request outside of iye app context; please use I18nYamlEditor#app_stack(iye_app)')
    end

    ##
    # Helper method to access filters param
    #
    # @return [Hash]
    def filters
      request.params['filters'] || {}
    end

    ##
    # Rack app stack with endpoints for given iye_app
    #
    # @param iye_app [I18nYamlEditor::App]
    # @return [Rack::Builder] rack app to be run
    def self.app_stack(iye_app)
      Rack::Builder.new do
        use AppEnv, iye_app
        run Web
      end
    end

    get '/debug' do
      render('debug.html', translations: app.store.translations.values)
    end

    # new
    get '/new' do
      render('new.html')
    end

    # create single key
    post '/create' do
      key = request.params['key']
      file_radix = request.params['file_radix']

      app.store.locales.each do |locale|
        name = "#{locale}.#{key}"
        file = Transformation.sub_locale_in_path(file_radix, LOCALE_PLACEHOLDER, locale)
        text = request.params["text_#{locale}"]
        if app.store.translations[name]
          app.store.translations[name].text = text
        else
          app.store.add_translation Translation.new(name: name, file: file, text: text)
        end
      end

      app.save_translations

      categories = app.store.categories.sort
      render('categories.html', categories: categories)
    end

    # index
    get '/' do
      if (filters = request.params['filters'])
        options = {}
        options[:key] = /#{filters['key']}/ if filters['key'].to_s.size > 0
        options[:text] = /#{filters['text']}/i if filters['text'].to_s.size > 0
        options[:complete] = false if filters['incomplete'] == 'on'
        options[:empty] = true if filters['empty'] == 'on'

        keys = app.store.filter_keys(options)

        render('translations.html', keys: keys,)
      else
        categories = app.store.categories.sort
        render('categories.html', categories: categories)
      end
    end

    # mass update
    post '/update' do
      if (translations = request.params['translations'])
        translations.each do |name, text|
          app.store.translations[name].text = text
        end
        app.save_translations
      end

      response.redirect "#{root_path}?#{Rack::Utils.build_nested_query(filters: filters)}"
    end

    # confirm key deletion
    get '/keys/:name/destroy' do
      name = request.params[:name]
      key = app.store.keys.fetch(name)

      render('destroy.html', key: key)
    end

    # delete key
    delete '/keys/:name' do
      name = request.params[:name]
      key = app.store.keys.fetch(name)
      key.translations.each do |translation|
        app.store.translations.delete(translation.name)
      end
      app.store.keys.delete(name)
      app.store.categories.delete(name) if key.category == key.name

      response.redirect(root_path)
    end

    ##
    # Middleware that sets iye_app in request environment
    # Used by I18nYamlEditor::Web#app_stack
    class AppEnv
      def initialize(app, iye_app)
        @app = app
        @iye_app = iye_app
      end

      def call(env)
        env['iye.app'] = @iye_app

        @app.call(env)
      end
    end
  end
end
