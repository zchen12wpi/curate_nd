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
          body = slugs.each_with_object({}) do |item_slug, memo|
            # Use a HEAD request with the Request-Cache header set to anything.
            resp = Faraday.head(item_url(item_slug)) do |req|
              req.headers['Request-Cache'] = '1'
            end
            memo[item_slug] = resp.status
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
