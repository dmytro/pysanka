class DataFolders < Middleman::Extension
  class DataFolder

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

    def data_folders
      DataFolders.data_folders
    end

    def dirs
      DataFolders.dirs
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
      data_folders[next_dir]
    end

    def prev
      data_folders[prev_dir]
    end

    def next?
      !send(:next).nil?
    end

    def prev?
      !prev.nil?
    end

    def count
      ::DataFolders.count
    end

    def first
      data_folders.values.first
    end

    def last
      data_folders.values.last
    end

    def files
      @files ||= Dir["#{::DataFolders::DATA_PATH}/#{dir}/*.{jpg,png,gif,JPG,PNG,GIF}"]
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
