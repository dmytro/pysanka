# -*- coding: utf-8 -*-
class Events < Middleman::Extension

  DATA_PATH="data/events"

  require_relative "events/event"
  require_relative "events/image"

  @@events = nil

  def initialize(app, options_hash={}, &block)
    super
    app.set :events, events
    @root = app.root
  end
  attr_reader :root

  def yaml
    @yaml ||= Dir.glob("#{DATA_PATH}/**/data.yml")
      .reduce({}) do |yaml, file|

      index = file.split("/")[-2]
      yaml[index] = YAML.load_file(file).merge(
        file: file,
        index: index.to_i,
        dir: index
      )

      yaml
    end
  end

  def events
    @@events ||= yaml.reduce({}) do |events,event|
      events[event.first] = Event.new event.last
      events
    end
  end

  def after_configuration
    events.values do |event|
      event.images.map(&:configure)
    end
  end


  class << self

    def dirs
      events.keys
    end

    def count
      events.count
    end

    def events
      @@events
    end

    def index
      "/events"
    end

    def current
      events.values.last
    end
  end

end

::Middleman::Extensions.register(:events, Events)
