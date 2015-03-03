# -*- coding: utf-8 -*-
# Example usage:
#     activate :data_folders, namespace: 'events'
#
# 1. Create folders in `./data/events`
# 2. Each event has own subdirectory: `./data/events/0001`, `./data/events/0002`, ...
# 3. Each subdirectory should have file `./data/events/0002/data.yml`
#
class DataFolders < Middleman::Extension

  option :namespace, "", "Name for global variable"

  require_relative "data_folders/data_folder"
  require_relative "data_folders/image"

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
