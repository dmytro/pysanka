# -*- coding: utf-8 -*-
class Products < Middleman::Extension
  ASSETS = "source/assets/images"
  ASSETS_URL = "products"
  PATH = "#{ASSETS}/products"

  require_relative "products/items"
  require_relative "products/item"
  require_relative "products/image"

  def initialize(app, options_hash={}, &block)
    super
  end

  attr_reader :path


  helpers do
    def products(limit=0, dir: nil)
      if dir
        ::Products::Item.new(dir)
      else
        ::Products::Items.items[0..(limit-1)]
      end
    end

    def products_list(limit=0)
      ::Products::Items.list[0..(limit-1)]
    end

  end

end

::Middleman::Extensions.register(:products, Products)
