# -*- coding: utf-8 -*-
class DataFolders < Middleman::Extension

  # option :data_path,       "", "Relative path to data"
  # option :assets_basename, "", "Relative URL of assets"
  option :namespace, "", "Name for global variable"

  require_relative "data_folders/data_folder"
  require_relative "data_folders/image"

  # @@data_folders = nil

  cattr_accessor :namespace

  def initialize(app, options_hash={}, &block)
    super

    @namespace  = options.namespace
    @@namespace = options.namespace

    @root = app.root

    app.set @namespace.to_sym, data_folders
    app.set "#{@namespace}_index".to_sym, "/#{@namespace}"
    app.set "#{@namespace}_current".to_sym, data_folders.values.last
  end
  attr_reader :root

  def after_configuration
    data_folders.values.each do |data_folder|
      puts "Building data #{data_folder.dir}"
      data_folder.images.map(&:configure)
    end
  end

  private

  def namespace
    @namespace.to_sym
  end

  def yaml
    @yaml ||= Dir.glob("#{self.class.data_path}/**/data.yml")
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

  class << self
    def data_path
      "data/#{ @@namespace }"
    end

    def dirs
      data_folders.keys
    end

    def count
      data_folders.count
    end

    def data_folders
      @@data_folders
    end
  end

end

::Middleman::Extensions.register(:data_folders, DataFolders)
