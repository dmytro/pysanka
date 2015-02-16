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


  class Event

    def initialize(yaml, index)
      @yaml = yaml
      @index = index
    end

    attr_reader :yaml, :data, :index

    def data
      OpenStruct.new yaml[index]
    end

    delegate :title, :date, :time, :subtitle, :description, :address,
      :photos, :title_photo, :price, :google_map,
      to: :data

    def count
      yaml.count
    end

    def url
      "/event_#{index}"
    end

    def has_next?
      index + 1 < count
    end

    def has_prev?
      index > 0
    end

    def first
      Event.new(yaml, 0)
    end

    def last
      Event.new(yaml, count)
    end

    def next
      Event.new(yaml, (index+1)) if has_next?
    end

    def prev
      Event.new(yaml, (index-1)) if has_prev?
    end

    def files
      @files ||= Dir["#{::Events::PATH}/#{data.photos}/*.{jpg,png,gif,JPG,PNG,GIF}"]
        .map { |x| x.sub("#{::Events::PATH}", ::Events::ASSETS_URL ) }
    end

    def thumbs
      @thumbs ||= files.grep(/_thumb\./)
    end

    def images
      @images ||= (files - thumbs).map do |path|
        Image.new path, thumbs
      end
    end

    def has_images?
      !images.empty?
    end

    class Image

      def initialize(path, thumbs)
        @path = path
        @thumbs = thumbs
      end

      attr_accessor :path, :thumbs

      def has_thumb?
        thumbs.include? would_be_thumb_file
      end

      def thumb
        has_thumb? ? would_be_thumb_file : path
      end

      def would_be_thumb_file
        path.sub(/^(.*)\.(jpg|gif|png)$/i, '\1_thumb.\2')
      end
    end

  end
end

::Middleman::Extensions.register(:events, Events)
