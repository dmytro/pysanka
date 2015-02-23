# -*- coding: utf-8 -*-
class Events < Middleman::Extension

  ASSETS = "source/assets/images"
  ASSETS_URL = "events"
  PATH = "#{ASSETS}/events"

  require_relative "events/event"

  def initialize(app, options_hash={}, &block)
    super
    @data_path = "#{ app.root }/data/events.yml"

    app.set :events, events
  end
  attr_reader :data_path

  def yaml
    @yaml ||= YAML.load_file(data_path)
  end

  def events
    @events ||= yaml.each_with_index.map do |hash, index|
      Event.new yaml, index
    end
  end

  def self.url
    "/events"
  end

end

::Middleman::Extensions.register(:events, Events)
