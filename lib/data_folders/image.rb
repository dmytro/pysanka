class DataFolders < Middleman::Extension
  class DataFolder

    DIMENSIONS = [640,480]

    ASSETS = "source/assets/images"

    class Image
      def initialize(original)
        @original = original
      end
      attr_reader :original

      def path
        "#{ASSETS}/#{DataFolders.assets_basename}"
      end

      def file
        @file ||= original.sub(::DataFolders.data_path, DataFolders.assets_basename)
      end

      def exists?
        File.exists? file
      end

      def url
        @url ||= file.sub(path, DataFolders.assets_basename )
      end

      def dir
        File.dirname file
      end

      def mk_target_dir
        Dir.mkdir dir unless Dir.exists? dir
      end

      def copy_to_assets(dimensions=DIMENSIONS, resize: :resize_to_fit)
        unless exists?
          mk_target_dir
          ::Magick::Image.read(original).first
            .send(resize, *dimensions)
            .write(file)
        end
      end

      def thumb
        Thumb.new original
      end

      def configure
        copy_to_assets
        thumb.copy_to_assets
      end

      class Thumb < Image
        SIZE=[75,75]
        def file
          @file ||= original
            .sub(::DataFolders.data_path, DataFolders.assets_basename)
            .sub(/\.(jpg|gif|png)$/i,'_thumb.\1')
        end

        def copy_to_assets
          super SIZE, resize: :resize_to_fill
        end
      end # Thumb
    end
  end
end
