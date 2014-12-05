# -*- coding: utf-8 -*-
class Showcase < Middleman::Extension
  ASSETS = "source/assets/images"
  ASSETS_URL = "showcase"
  PATH = "#{ASSETS}/showcase"
  DEFAULTS =  {
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

  def initialize(app, options_hash={}, &block)
    super
  end

  attr_reader :path

  class Items

    attr_reader :path
    def initialize
      @path = Showcase::PATH
    end

    class << self
    def dirs
      Dir.glob("#{self.new.path}/*").select { |fn| File.directory?(fn) }
    end


    def basenames
      dirs.map { |f| File.basename f }
    end

    alias :list :basenames


    def defaults
      Showcase::DEFAULTS
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
  end

  class Item

    attr_reader :path, :data

    def initialize(path)
      @path = path
    end

    def basename
      @basename ||= File.basename path
    end

    def data_file
      @data_file ||= "#{path}/data.yml"
    end

    def data
      @data ||= (File.exists?(data_file) ? YAML.load_file(data_file) : {  })
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

  class Image
    def initialize(dir,file)
      @dir = File.basename dir
      @file = file
    end
    attr_reader :file, :dir

    def path
      File.expand_path("#{Showcase::PATH}/#{dir}/#{file}")
    end

    def url
      "#{Showcase::ASSETS_URL}/#{dir}/#{file}"
    end
  end

  helpers do
    def showcase(limit=0)
      ::Showcase::Items.items[0..(limit-1)]
    end

    def showcase_list(limit=0)
      ::Showcase::Items.list[0..(limit-1)]
    end
  end

end

::Middleman::Extensions.register(:showcase, Showcase)
