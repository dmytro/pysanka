class Events < Middleman::Extension
  class Image
    def initialize(dir,file)
      @dir = File.basename dir
      @file = file
    end
    attr_reader :file, :dir

    def path
      File.expand_path("#{Events::PATH}/#{dir}/#{file}")
    end

    def url
      "#{Events::ASSETS_URL}/#{dir}/#{file}"
    end
  end
end
