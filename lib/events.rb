# -*- coding: utf-8 -*-
class Events < Middleman::Extension

  ASSETS = "source/assets/images"
  ASSETS_URL = "events"
  PATH = "#{ASSETS}/events"

  # require_relative "showcase/items"

  def initialize(app, options_hash={}, &block)
    super
  end


  helpers do
    def next_event
    end
  end

end

::Middleman::Extensions.register(:events, Events)
