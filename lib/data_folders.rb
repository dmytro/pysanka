# -*- coding: utf-8 -*-
class DataFolders < Middleman::Extension

  option :data_path,       "", "Relative path to data"
  option :assets_basename, "", "Relative URL of assets"
  option :namespace, "", "Name for global variable"

  require_relative "data_folders/data_folder"
  require_relative "data_folders/image"

  @@data_folders = nil
  @@data_path = nil
  @@assets_basename = nil

  cattr_accessor :assets_basename, :data_path

  def initialize(app, options_hash={}, &block)
    super

    @@data_path = options.data_path
    @@assets_basename = options.assets_basename

    @namespace = options.namespace

    @root = app.root

    app.set @namespace.to_sym, data_folders
  end
  attr_reader :root

  def namespace
    @namespace.to_sym
  end

  def yaml
    @yaml ||= Dir.glob("#{@@data_path}/**/data.yml")
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

    # def assets_basename
    #   @@assets_basename
    # end

    # def data_path
    #   @@data_path
    # end

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
