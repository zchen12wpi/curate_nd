module Bendo
  module Services
    class FixityChecks
      Response = Struct.new(:status, :body)

      def self.call(params: params)
        new.get(params: params)
      end

      def get(params: params)
        query_params = transform_params(params: params).compact.join("&")
        url = Bendo.fixity_url() + "?#{query_params}"
        conn = Faraday.new url: url, headers: { 'X-Api-Key' => Bendo.api_key() }
        result = conn.get
        # A Bendo response body is only valid json if success
        body = result.status === 200 ? JSON.parse(result.body) : result.body
        Response.new(result.status, body)
      end

      # Transforms from params Curate understands to params that Bendo understands. Inherently whitelists params as well
      def transform_params(params: params)
        params.map do |k,v|
          new_key = param_map[k]
          new_key.present? ? "#{new_key}=#{v}" : nil
        end
      end

      def param_map
        @param_map ||= { "item" => "item", "status" => "status", "scheduled_time_start" => "start", "scheduled_time_end" => "end" }.freeze
      end
    end
  end
end
