module Bendo
  module Services
    module FakeApi
      def self.call(slugs)
        results = {}
        slugs.map{ |slug| results[slug] = true }
        Response.new(status: 200, body: results)
      end

      class Response
        def initialize(status: nil, body: nil)
          @status = status
          @body = body
        end

        attr_reader :status, :body
      end
    end
  end
end
