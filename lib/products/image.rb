# -*- coding: utf-8 -*-
class Products < Middleman::Extension
  class Image
    def initialize(dir,file)
      @dir = File.basename dir
      @file = file
    end
    attr_reader :file, :dir

    def path
      File.expand_path("#{Products::PATH}/#{dir}/#{file}")
    end

    def url
      "#{Products::ASSETS_URL}/#{dir}/#{file}"
    end
  end
end
