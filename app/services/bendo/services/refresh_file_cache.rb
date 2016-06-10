module Bendo
  module Services
    module RefreshFileCache

      def call(item_slugs: [], handler: BendoApi)
        slugs = Array.wrap(item_slugs)
        handler.call(slugs)
      end
      module_function :call

      module BendoApi
        Response = Struct.new(:status, :body)

        def call(slugs)
          # Refreshing the cache is the same processes as requesting a downlowd.
          # The only difference is that the GET request should be closed instead
          # of waiting for all of the body to be sent. The easiest way to do
          # this is with HTTP streaming.
          body = slugs.each_with_object({}) do |item_slug, memo|
            memo[item_slug] = true
          end
          Response.new(200, body.to_json)
        end
        module_function :call
      end

    end
  end
end
