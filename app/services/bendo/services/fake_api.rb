module Bendo
  module Services
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
