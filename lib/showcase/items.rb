# -*- coding: utf-8 -*-
class Showcase < Middleman::Extension
  # All showsace items array
  class Items

    attr_reader :path
    def initialize
      @path = Showcase::PATH
    end

    class << self

      def dirs
        @dirs ||= Dir.glob("#{self.new.path}/*").select { |fn| File.directory?(fn) }
      end

      def basenames
        @basenames ||= dirs.map { |f| File.basename f }
      end

      alias :list :basenames

      def items
        basenames.map { |dir| Showcase::Item.new(dir) }
      end
    end
  end
end
