require 'active_support/core_ext/array/wrap'

module Bendo
  module Services
    module FileCacheStatus
      CACHE_HIT_RESPONSE = true
      CACHE_MISS_RESPONSE = false
      NEVER_CACHED_RESPONSE = 'never'.freeze
      ERROR_RESPONSE = 'error'.freeze

      CACHE_STATUS_RESPONSE_MAP = Hash.new(ERROR_RESPONSE).merge(
        '0' => CACHE_MISS_RESPONSE,
        '1' => CACHE_HIT_RESPONSE,
        '2' => NEVER_CACHED_RESPONSE
      )

      def self.call(item_slugs: [], handler: BendoApi)
        slugs = Array.wrap(item_slugs)
        handler.call(slugs)
      end

      module BendoApi
        Response = Struct.new(:status, :body)

        def self.call(item_slugs)
          body = item_slugs.each_with_object({}) do |item_slug, memo|
            response = Faraday.head Bendo.item_url(item_slug)
            cache_status = response.headers.fetch('x-cached', nil)
            memo[item_slug] = CACHE_STATUS_RESPONSE_MAP[cache_status]
          end
          Response.new(200, body.to_json)
        end
      end
    end
  end
end
