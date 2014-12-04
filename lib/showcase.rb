# -*- coding: utf-8 -*-
class Showcase < Middleman::Extension
  def initialize(app, options_hash={}, &block)
    super
  end

  attr_reader :path

  class Items

    attr_reader :path
    def initialize #(path)
      @path = "source/images/showcase"
    end

    def dirs
      Dir.glob("#{path}/*").select { |fn| File.directory?(fn) }
    end

    def defaults
      {
        title: "Title",
        subtitle: "Sub Title",
        summary: "Що небудь про писанку...",
        link_to: "/",
        "Read more" => {
          uk: "Читати далі",
          ja: "続きを読む",
          en: "Read more"
          }
      }
    end

    def items
      dirs.map do |dir|

        item = ::Showcase::Item.new(dir)

        OpenStruct.new({
          dir: dir,
            images: item.images,
            thumb: item.thumb,
            asset_path: item.asset_path,
            data: OpenStruct.new(defaults.merge(item.data))

        })
      end
    end
  end

  class Item

    attr_reader :path, :data

    def initialize(path)
      @path = path
    end

    def data_file
      @data_file ||= "#{path}/data.yml"
    end

    def data
      @data ||= (File.exists?(data_file) ? YAML.load_file(data_file) : {  })
    end

    def asset_path
      @asset_path ||= path.gsub("source/images/","")
    end

    def image_files
      @images ||= Dir.entries("#{ path }").grep(/\.jpg$/i )
    end

    def images
      image_files.map { |x| "#{ asset_path }/#{ x }" }
    end

    def thumbs
      @thumbs ||= images.grep(/_thumb\.jpg$/)
    end

    def thumb
      thumbs.first || images.first
    end

  end

  helpers do

    def showcase(limit=0)
      ::Showcase::Items.new.items[0..(limit-1)]
    end

  end
end

::Middleman::Extensions.register(:showcase, Showcase)
