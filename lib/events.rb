# -*- coding: utf-8 -*-
class Events < Middleman::Extension

  ASSETS = "source/assets/images"
  ASSETS_URL = "events"
  PATH = "#{ASSETS}/events"

  require_relative "events/event"

  @@events = nil

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
    @@events ||= yaml.each_with_index.map do |hash, index|
      Event.new yaml, index
    end
  end

  class << self
    def events
      @@events
    end

    def index
      "/events"
    end

    def current
      events.first
    end
  end

end

::Middleman::Extensions.register(:events, Events)
