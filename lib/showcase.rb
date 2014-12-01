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

    def items
      dirs.map do |dir|
        item = ::Showcase::Item.new(dir)
        {
          dir: dir,
            images: item.images,
            thumb: item.thumb,
            asset_path: item.asset_path
        }
      end
    end
  end

  class Item

    attr_reader :path

    def initialize(path)
      @path = path
    end

    def asset_path
      @asset_path ||= path.gsub("source/images/","")
    end

    def images
      @images ||= Dir.entries("#{ path }").grep(/\.jpg$/i )
    end

    def thumbs
      @thumbs ||= images.grep(/_thumb\.jpg$/)
    end

    def thumb
      thumbs.first || images.first
    end

  end

  helpers do

    def showcase_items(limit=0)
      ::Showcase::Items.new.items[0..(limit-1)]
    end

  end
end

::Middleman::Extensions.register(:showcase, Showcase)
