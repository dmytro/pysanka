# -*- coding: utf-8 -*-
require 'slim'
Slim::Engine.disable_option_validator!

#$. << "./lib"
require "#{File.dirname(__FILE__)}/lib/showcase"
require "#{File.dirname(__FILE__)}/lib/events"
activate :events

I18n.enforce_available_locales = true
# general settings
set :encoding, 'utf-8'
set :index_file, 'index.html'
set :css_dir, 'assets/stylesheets'
set :js_dir, 'assets/javascripts'
set :images_dir, 'assets/images'
set :partials_dir, 'partials'
set :haml, { :format => :html5 }

ignore '*.less'

# don't precompile assets when middleman startup, but only when it's requested.
#set :debug_assets, true

activate :livereload

activate :i18n, langs: [:ja, :en, :uk]

activate :directory_indexes

page '/', layout: 'layout'

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

  def available_locales_as_regex
    I18n.config.available_locales.map(&:to_s).join("|")
  end

  def current_without_locale
    current_page.url
    .sub(%r{^/(#{ available_locales_as_regex})/},'/')
  end

  def current_with_locale(locale)
    if locale == I18n.default_locale.to_s
      current_without_locale
    else
      "/#{locale}/#{current_without_locale}"
    end
      .gsub(%r{/+}, "/")
  end

  # Translate strings that are not part of /locale/ directory.
  def l(key, split: false)
    string = ((key.is_a?(Hash) ? key[I18n.locale.to_s] : key) || "")
    if split
      string.gsub(/\n+/, "<p>")
    else
      string
    end
  end

  def locale_prefix
    if I18n.locale == I18n.default_locale
      "/"
    else
      "/#{I18n.locale.to_s}"
    end
  end

  def localized_href(href)
    "/#{locale_prefix}/#{href}".gsub(%r{/+}, "/")
  end

end

# --------------------------------------------
# Showcase is Pysanka products lister
# --------------------------------------------
activate :showcase
Showcase::Items.list.each do |dir|
  proxy "/uk/item_#{dir}.html", "product.html",
    locals: { item: ::Showcase::Item.new(dir), lang: :ua },
    ignore: true do
    ::I18n.locale = :uk
    @lang = :uk
  end

  proxy "/item_#{dir}.html", "product.html",
    locals: { item: ::Showcase::Item.new(dir), lang: :ja },
    ignore: true do
    ::I18n.locale = :ja
    @lang = :ja
  end

  proxy "/en/item_#{dir}.html", "product.html",
    locals: { item: ::Showcase::Item.new(dir), lang: :en },
    ignore: true do
    ::I18n.locale = :en
    @lang = :en
  end
end


helpers do
  def showcase_item_link(item)
    "<a href='#{localized_href item.url}'>#{item.basename.to_i}</a>"
  end
end

# --------------------------------------------
# Events full description
# --------------------------------------------
activate :showcase
events.each do |event|


  proxy "/uk/event/#{event.index}.html", "event.html",
    locals: { event: event, lang: :ua },
    ignore: true do
    ::I18n.locale = :uk
    @lang = :uk
  end

  proxy "/event/#{event.index}.html", "event.html",
    locals: { event: event, lang: :ja },
    ignore: true do
    ::I18n.locale = :ja
    @lang = :ja
  end

  proxy "/en/event/#{event.index}.html", "event.html",
    locals: { event: event, lang: :en },
    ignore: true do
    ::I18n.locale = :en
    @lang = :en
  end
end

configure :build do
  activate :relative_assets
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
  ignore(/\.DS_Store/)
  ignore(/^assets.*\.yml/)
  ignore(/^assets\/stylesheets\/(?!all).*\.css/)
  ignore(/^assets\/javascripts\/(?!all).*\.js/)
  ignore(%r{^assets/stylesheets/colorschemas/.*})
  ignore(%r{^assets/images/homepage-slider/pysanka-.*\.jpg$})
  ignore(%r{/src/})


  # if ENV['CDN_HOST']
  #   activate :asset_host
  #   set :asset_host, ENV['CDN_HOST']
  # end
end
