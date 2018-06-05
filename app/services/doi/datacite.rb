module Doi
  class Datacite
    def self.mint(target)
      doi_request_object = DataciteMapper.call(target)
      Ezid::Identifier.mint(doi_request_object).id
    end

    def self.normalize_identifier(value)
      value.to_s.strip.
        sub(/\A#{resolver_url}\/*/, '').
        sub(/\A\s*doi:\s+/, 'doi:').
        sub(/\A(\d.*)/, 'doi:\1').
        sub(/\Adoi\s*:\s*/, 'doi:').
        sub(/\A(doi:\d*.\d*)\s*\/\s*(\w*)/, '\1/\2')
    end

    def self.remote_uri_for(identifier)
      URI.parse(File.join(resolver_url, identifier))
    end

    private

    def self.resolver_url
      ENV.fetch('DOI_RESOLVER')
    end
  end
end
