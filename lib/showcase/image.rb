# -*- coding: utf-8 -*-
class Showcase < Middleman::Extension
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
end
