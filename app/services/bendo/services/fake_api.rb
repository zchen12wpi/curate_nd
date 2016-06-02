module Bendo
  module Services
    module FakeApi
      module_function

      def call(ids)
        results = {}
        ids.map{ |id| results[id] = true }
        Response.new(status: 200, body: results)
      end

      class Response
        def initialize(status: status, body: body)
          @status = status
          @body = body
        end

        attr_reader :status, :body
      end
    end
  end
end
