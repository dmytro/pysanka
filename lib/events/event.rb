class Events < Middleman::Extension
  class Event
    def initialize(data, index)
      @photos = data.photos
      @index = index
    end
    attr_reader :photos, :index

    # def pictures
    # end

    # def path
    #   File.expand_path("#{Events::PATH}/#{dir}/#{file}")
    # end

    # def url
    #   "#{Events::ASSETS_URL}/#{dir}/#{file}"
    # end
  end
end
