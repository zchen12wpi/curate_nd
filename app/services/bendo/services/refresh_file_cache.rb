require 'active_support/core_ext/array/wrap'
require 'uri'

module Bendo
  module Services
    module RefreshFileCache

      def self.call(item_slugs: [], handler: BendoApi)
        slugs = Array.wrap(item_slugs)
        handler.call(slugs)
      end

      module BendoApi
        Response = Struct.new(:status, :body)

        def self.call(slugs)
          # Refreshing the cache is the same processes as requesting a downlowd.
          # The only difference is that the GET request should be closed instead
          # of waiting for all of the body to be sent. The easiest way to do
          # this is with HTTP streaming.
          body = slugs.each_with_object({}) do |item_slug, memo|
            uri = URI.parse(item_url(item_slug))
            status = 500
            begin
              Net::HTTP.start(uri.host, uri.port) do |http|
                request = Net::HTTP::Get.new uri

                http.request request do |response|
                  response.read_body do |chunk|
                    status = response.code.to_i
                    http.finish
                  end
                end
              end
            rescue NoMethodError
              logger.info "Prematurely and deliberately terminated request for #{uri} to warm the cache"
            end
            memo[item_slug] = status
          end

          Response.new(200, body.to_json)
        end

        def self.item_url(item_slug)
          Bendo.item_url(item_slug)
        end
      end
    end
  end
end
