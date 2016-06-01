module Bendo
  module Services
    module FileCacheStatus

      def call(id: [], handler: BendoApi)
        ids = Array.wrap(id)
        handler.call(ids)
      end
      module_function :call

      module BendoApi
        module_function
        def call(ids)
          raise "Not implmented"
        end
      end

      module FakeApi
        module_function

        def call(ids)
          results = {}
          ids.map{ |id| results[id] = true }
          results
        end
      end

    end
  end
end
