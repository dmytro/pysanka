require 'slim'
Slim::Engine.disable_option_validator!

#$. << "lib"
require "#{File.dirname(__FILE__)}/lib/showcase"
I18n.enforce_available_locales = true
# general settings
set :encoding, 'utf-8'
set :index_file, 'index.html'
set :css_dir, 'assets/stylesheets'
set :js_dir, 'assets/javascripts'
set :images_dir, 'assets/images'
set :haml, { :format => :html5 }

ignore '*.less'

# don't precompile assets when middleman startup, but only when it's requested.
#set :debug_assets, true

activate :livereload

activate :i18n, langs: [:en, :uk, :ja]

activate :directory_indexes

page '/', layout: 'layout'
# page '/en', layout: 'layout'
# page '/en', layout: 'layout'

set :markdown, :tables => true, :autolink => true, :gh_blockcode => true, :fenced_code_blocks => true, :with_toc_data => true
set :markdown_engine, :redcarpet

configure :development do
  activate :relative_assets
end

# --------------------------------------------
# Localization helpers
# --------------------------------------------
helpers do
  def current_language
    data.languages[I18n.locale]
  end

  # Get the current page URL without locale prepended
  def current_without_locale
    current_page.path.sub!("^\/?#{I18n.locale}\/", "")
  end

  def current_with_locale(locale)
    case locale
    when 'en'
      "#{current_without_locale}"
    else
      "#{locale}/#{current_without_locale}"
    end
  end

  # Translate strings that are not part of /locale/ directory.
  def l(key)
    key.is_a?(Hash) ? key[I18n.locale.to_s] : key
  end
end

# --------------------------------------------
# Showcase is Pysanka products lister
# --------------------------------------------
activate :showcase
# showcase_dirs.each do |product|
#   proxy "#{product}.html", "product.html", locale: :en do
#     # ::I18n.locale = :en
#     # @lang         = :en

#     @path = product
#   end
# end

configure :build do
  # activate :directory_indexes
  activate :sprockets
  activate :minify_css
  activate :minify_javascript
  # somehow minifying html takes some html attributes away so it is causing
  # some css not applied to certain elements... so until we find alternative
  # way to monify html, we will disable this
  #activate :minify_html
  activate :asset_hash
  #activate :gzip
  ignore 'product.html'
  ignore(/Icon\r$/)
  ignore(/^assets.*\.yml/)

  # if ENV['CDN_HOST']
  #   activate :asset_host
  #   set :asset_host, ENV['CDN_HOST']
  # end
end
