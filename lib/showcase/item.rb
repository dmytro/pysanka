# -*- coding: utf-8 -*-
class Showcase < Middleman::Extension
  class Item

    attr_reader :path, :data, :dir

    def initialize(dir)
      @dir = dir
      @path = "#{Showcase::PATH}/#{dir}"
    end

    alias :basename :dir

    def related(count=3)
      Items.items.sample(count)
    end

    def defaults
      Showcase::DEFAULTS
    end

    delegate :title, :subtitle, :summary, :description, :link_to,
      to: :data, allow_nil: true

    def data_file
      @data_file ||= "#{path}/data.yml"
    end

    def data
      @data ||= OpenStruct.new(
        defaults.merge(
          (File.exists?(data_file) ? YAML.load_file(data_file) : {})
        )
      )
    end

    def url
      @url ||= (link_to || "item_#{dir}")
    end


    def asset_path
      @asset_path ||= path.gsub(Showcase::ASSETS,"")
    end

    def images
      @images ||= Dir.entries("#{ path }").grep(/\.jpg$/i )
        .map { |f| Image.new(path,f) }
    end

    def thumbs
      @thumbs ||= images.find { |i| i.file =~ /_thumb\.jpg$/} || []
    end

    def thumb
      thumbs.first || images.first
    end

  end
end
