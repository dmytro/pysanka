# -*- coding: utf-8 -*-
class Products < Middleman::Extension
  class Item

    attr_reader :path, :data, :dir

    def initialize(dir)
      @dir = dir
      @path = "#{Products::PATH}/#{dir}"
    end

    alias :basename :dir

    def related(count=3)
      Items.items.sample(count)
    end


    delegate :title, :subtitle, :summary, :description, :link_to,
      to: :data, allow_nil: true

    def data_present?
      !title.blank? || !subtitle.blank? || !description.blank? || !summary.blank?
    end

    def data_file
      @data_file ||= "#{path}/data.yml"
    end

    def number
      dir.to_i
    end

    def data
      @data ||= OpenStruct.new(
        Items.data.merge(
          (File.exists?(data_file) ? YAML.load_file(data_file) : {})
        )
      )
    end

    def url
      @url ||= (link_to || "item_#{number}")
    end


    def asset_path
      @asset_path ||= path.gsub(Products::ASSETS,"")
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
