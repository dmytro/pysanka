# -*- coding: utf-8 -*-
class DataFolders < Middleman::Extension

  DATA_PATH="data/events"

  require_relative "data_folders/data_folder"
  require_relative "data_folders/image"

  @@data_folders = nil

  def initialize(app, options_hash={}, &block)
    super
    app.set :data_folders, data_folders
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

  def data_folders
    @@data_folders ||= yaml.reduce({}) do |data_folders,data_folder|
      data_folders[data_folder.first] = DataFolder.new data_folder.last
      data_folders
    end
  end

  def after_configuration
    data_folders.values do |data_folder|
      data_folder.images.map(&:configure)
    end
  end


  class << self

    def dirs
      data_folders.keys
    end

    def count
      data_folders.count
    end

    def data_folders
      @@data_folders
    end

    def index
      "/events"
    end

    def current
      data_folders.values.last
    end
  end

end

::Middleman::Extensions.register(:data_folders, DataFolders)
