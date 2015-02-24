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

    def events
      Events.events
    end

    def dirs
      Events.dirs
    end

    def dir
      yaml[:dir]
    end

    def next_dir
      dirs[dirs.find_index(dir)+1]
    end

    def prev_dir
      idx = dirs.find_index(dir)-1
      return idx < 0 ? nil : dirs[idx]
    end

    def next
      events[next_dir]
    end

    def prev
      events[prev_dir]
    end

    def next?
      !send(:next).nil?
    end

    def prev?
      !prev.nil?
    end

    def count
      ::Events.count
    end

    def first
      events.values.first
    end

    def last
      events.values.last
    end

    def files
      @files ||= Dir["#{::Events::DATA_PATH}/#{dir}/*.{jpg,png,gif,JPG,PNG,GIF}"]
    end

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
