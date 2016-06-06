module Bendo
  module Services
    module FileCacheStatus

      def call(item_slugs: [], handler: BendoApi)
        slugs = Array.wrap(item_slugs)
        handler.call(slugs)
      end
      module_function :call

      module BendoApi
        Response = Struct.new(:status, :body)

        def call(item_slugs)
          body = item_slugs.each_with_object({}) do |item_slug, memo|
            response = Faraday.head Bendo.item_url(item_slug)
            is_cached = response.headers.fetch('x-cached') != '0'
            memo[item_slug] = is_cached
          end
          Response.new(200, body.to_json)
        end
        module_function :call
      end

    end
  end
end
