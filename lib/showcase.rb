# -*- coding: utf-8 -*-
class Showcase < Middleman::Extension
  ASSETS = "source/assets/images"
  ASSETS_URL = "showcase"
  PATH = "#{ASSETS}/showcase"
  DEFAULTS =  {
    title: "Title",
    subtitle: "Sub Title",
    summary: "Що небудь про писанку...",
  }

  require_relative "showcase/items"
  require_relative "showcase/item"
  require_relative "showcase/image"

  def initialize(app, options_hash={}, &block)
    super
  end

  attr_reader :path


  helpers do
    def showcase(limit=0, dir: nil)
      if dir
        ::Showcase::Item.new(dir)
      else
        ::Showcase::Items.items[0..(limit-1)]
      end
    end

    def showcase_list(limit=0)
      ::Showcase::Items.list[0..(limit-1)]
    end

  end

end

::Middleman::Extensions.register(:showcase, Showcase)
