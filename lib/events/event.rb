class Events < Middleman::Extension
  class Event

    def initialize(yaml)
      @yaml = yaml
      @index = yaml[:index]
    end

    attr_reader :yaml, :index

    def data
      OpenStruct.new yaml
    end

    def link
      "event/#{index}"
    end
    alias :url :link

    delegate :title, :date, :time, :subtitle, :description, :address,
      :photos, :title_photo, :price, :google_map,
      to: :data

    def index_s
      "%04d" % index
    end

    def count
      ::Events.count
    end

    def has_next?
      index + 1 < count
    end

    def has_prev?
      index > 0
    end

    def first
      Events.events.first
    end

    def last
      Events.events.last
    end

    def next
      Events.events[index+1] if has_next?
    end

    def prev
      Events.events[index-1] if has_prev?
    end

    def files
      @files ||= Dir["#{::Events::DATA_PATH}/#{index_s}/*.{jpg,png,gif,JPG,PNG,GIF}"]
    end

    # def files
    #   @files ||= originals.map { |x| x.sub("#{::Events::PATH}", ::Events::ASSETS_URL ) }
    # end

    # def thumbs
    #   @thumbs ||= files.grep(/_thumb\./)
    # end

    def images
      @images ||= files.map do |path|
        Image.new path
      end
    end

    def has_images?
      !images.empty?
    end

  end
end
