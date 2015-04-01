# -*- coding: utf-8 -*-
class Products < Middleman::Extension
  # All showsace items array
  class Items

    attr_reader :path
    def initialize
      @path = Products::PATH
    end
    class << self

      def data
        File.exists?(data_file) ? YAML.load_file(data_file) : {}
      end

      def data_file
        @data_file ||= "#{Items.new.path}/data.yml"
      end


      def dirs
        @dirs ||= Dir.glob("#{self.new.path}/*").select { |fn| File.directory?(fn) }
      end

      def basenames
        @basenames ||= dirs.map { |f| File.basename f }
      end

      alias :list :basenames

      def items
        basenames.map { |dir| Products::Item.new(dir) }
      end
    end
  end
end
