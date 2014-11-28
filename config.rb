require 'slim'
Slim::Engine.disable_option_validator!

# general settings
set :encoding, 'utf-8'
set :index_file, 'index.html'
set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :haml, { :format => :html5 }

# don't precompile assets when middleman startup, but only when it's requested.
set :debug_assets, true


activate :livereload

activate :i18n

activate :directory_indexes

set :markdown, :tables => true, :autolink => true, :gh_blockcode => true, :fenced_code_blocks => true, :with_toc_data => true
set :markdown_engine, :redcarpet

configure :development do
  activate :relative_assets
end

# configure :build do
#   activate :minify_css
#   activate :minify_javascript
# end

configure :build do
#  activate :directory_indexes
  activate :sprockets
  activate :minify_css
  activate :minify_javascript
  # somehow minifying html takes some html attributes away so it is causing
  # some css not applied to certain elements... so until we find alternative
  # way to monify html, we will disable this
  #activate :minify_html
  activate :asset_hash
  #activate :gzip

  if ENV['CDN_HOST']
    activate :asset_host
    set :asset_host, ENV['CDN_HOST']
  end
end
