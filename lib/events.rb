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
      .sort { |a,b| b.to_i <=> a.to_i }
      .map do |file|
      YAML.load_file(file).merge(
        file: file,
        index: file.split("/")[-2].to_i
      )
    end
  end

  def events
    @@events ||= yaml.map do |hash|
      Event.new hash
    end
  end

  def after_configuration
    events.map do |event|
      event.images.map(&:configure)
    end
  end


  class << self

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
      events.first
    end
  end

end

::Middleman::Extensions.register(:events, Events)
