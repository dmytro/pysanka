class Events < Middleman::Extension

  require 'RMagick'
  class Event

    DIMENSIONS = [640,480]

    ASSETS = "source/assets/images"
    ASSETS_URL = "events"
    PATH = "#{ASSETS}/events"

    class Image
      def initialize(original)
        @original = original
      end
      attr_reader :original

      def file
        @file ||= original.sub(::Events::DATA_PATH, "#{ ASSETS }/events")
      end

      def exists?
        File.exists? file
      end

      def url
        @url ||= file.sub(PATH, ASSETS_URL )
      end

      def dir
        File.dirname file
      end

      def mk_target_dir
        Dir.mkdir dir unless Dir.exists? dir
      end

      def copy_file(dimensions=DIMENSIONS)
        unless exists?
          mk_target_dir
          ::Magick::Image.read(original).first
            .resize_to_fill(*dimensions)
            .write(file)
        end
      end

      def thumb
        Thumb.new original
      end

      class Thumb < Image
        THUMB=[150,150]
        def file
          @file ||= original
            .sub(::Events::DATA_PATH, "#{ ASSETS }/events")
            .sub(/\.(jpg|gif|png)$/i,'_thumb.\1')
        end

        def copy_file
          super THUMB
        end

      end


      def configure
        copy_file
        thumb.copy_file
      end


    end

  end
end
