require 'URI'

module Bendo
  class DatastreamPresenter
    attr_reader :datastream

    def initialize(datastream)
      @datastream = datastream
    end

    def valid?
      @valid ||= is_redirect? && is_bendo_url?
    end

    def location
      @location ||= find_location
    end

    def item_path
      if location
        @item_path ||= find_item_path
      else
        nil
      end
    end
    alias_method :item_slug, :item_path

    private

    def find_item_path
      uri = URI.parse(location)
      if uri.respond_to?(:path)
        uri.path
      else
        nil
      end
    end

    def find_location
      if datastream.respond_to?(:location)
        datastream.location
      else
        nil
      end
    end

    def is_redirect?
      control_group = nil
      if datastream.respond_to?(:controlGroup)
        control_group = datastream.controlGroup
      end
      control_group == 'R'
    end

    def is_bendo_url?
      return false unless location
      Bendo.url == location[0...Bendo.url.length]
    end
  end
end
