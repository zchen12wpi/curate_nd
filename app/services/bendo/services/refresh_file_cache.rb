module Bendo
  module Services
    module RefreshFileCache

      def call(id: [], handler: BendoApi)
        ids = Array.wrap(id)
        handler.call(ids)
      end
      module_function :call

      module BendoApi
        def call(ids)
          raise "Not implmented"
        end
        module_function :call
      end

    end
  end
end
