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
    # if new_settings is nil, use defaults. Otherwise
    # use :server and :pool keys
    #
    # This method is exposed primarily for testing
    def self.configure(new_settings)
      if new_settings
        # use the template in the pool instead of the configured one
        @service = ::NoidsClient::Connection.new(new_settings[:server]).get_pool(new_settings[:pool])
        @template = @service.template.split("+").first
      else
        @service = nil
        @template = Sufia.config.noid_template
      end
      @minter = ::Noid::Minter.new(template: @template)
      @namespace = Sufia.config.id_namespace
    end

    configure(Sufia.config.noids)

    def self.noid_template
      @template
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
      id = @service ? @service.mint.first : @minter.mint
      "#{@namespace}:#{id}"
    end
  end
end
