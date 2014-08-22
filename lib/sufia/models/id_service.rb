require "noid"
require "noids_client"

# Monkey patch the id service to query an external noid service
# when the following configuration variable is set:
#
# Sufia::Engine.config.noids = {
#   server: "localhost:13001",
#   pool: "sufia"
# }
#
module Sufia
  module IdService
    # adapt NoidsClient connection to look like Noid::Minter
    class NoidAdapter
      def initialize(new_settings)
        @server = new_settings[:server]
        @pool = new_settings[:pool]
      end

      def mint
        service.mint.first
      end

      def template
        @template ||= service.template.split("+").first
      end

      def valid?(id)
        ::Noid::Minter.new(template: template).valid?(id)
      end

      protected

      def service
        @service ||= ::NoidsClient::Connection.new(@server).get_pool(@pool)
      end
    end

    # if new_settings is nil, use defaults. Otherwise
    # use :server and :pool keys
    #
    # This method is exposed primarily for testing
    def self.configure(new_settings)
      if new_settings
        # use the template in the pool instead of the configured one
        @minter = NoidAdapter.new(new_settings)
        @template = nil
      else
        # Hack. Noid::Minter doesn't give us the template string directly.
        # so, save it locally
        @template = Sufia.config.noid_template
        @minter = ::Noid::Minter.new(template: @template)
      end
      @namespace = Sufia.config.id_namespace
    end

    configure(Sufia.config.noids)

    def self.noid_template
      # the RHS should only execute if we are using the NoidAdapter.
      # see hack above
      @template ||= @minter.template
    end

    def self.valid?(identifier)
      # remove the fedora namespace since it's not part of the noid
      noid = identifier.split(":").last
      @minter.valid? noid
    end

    def self.mint
      loop do
        pid = next_id
        return pid unless ActiveFedora::Base.exists?(pid)
      end
    end

    protected

    def self.next_id
      "#{@namespace}:#{@minter.mint}"
    end

    # adapt NoidsClient connection to look like Noid::Minter
    class NoidAdapter
      def initialize(new_settings)
        @server = new_settings[:server]
        @pool = new_settings[:pool]
      end

      def mint
        service.mint.first
      end

      def template
        @template ||= service.template.split("+").first
      end

      def valid?(id)
        ::Noid::Minter.new(template: template).valid?(id)
      end

      protected

      def service
        @service ||= ::NoidsClient::Connection.new(@server).get_pool(@pool)
      end
    end
  end
end
