module CurationConcern
  module WithGenericFiles
    extend ActiveSupport::Concern

    included do
      has_many :generic_files, property: :is_part_of
      before_destroy :before_destroy_cleanup_generic_files
    end

    def before_destroy_cleanup_generic_files
      generic_files.each(&:destroy)
    end

    # An alternative to #generic_files, allows querying for associated files a page at a time.
    # Returns a tuple where the first item is a SolrResponse that can be used for pagination,
    # and the second is an array of GenericFiles
    def generic_files_page(page, per_page)
      escaped_uri = ActiveFedora::SolrService.escape_uri_for_query(internal_uri)
      escaped_model = ActiveFedora::SolrService.escape_uri_for_query("info:fedora/afmodel:GenericFile")
      q = "is_part_of_ssim:#{escaped_uri}"
      fq = "has_model_ssim:#{escaped_model}"
      per_page = per_page > 0 ? per_page : 10
      start = page > 0 ? (page - 1) * per_page : 0
      request_params = { fq: fq, start: start, rows: per_page }
      solr_response = ActiveFedora::SolrService.query(q, raw: true, **request_params)
      page = Blacklight::SolrResponse.new(solr_response, request_params)
      generic_file_streams = ActiveFedora::SolrService.reify_solr_results(solr_response['response']['docs'])
      return [page, generic_file_streams]
    end

    def with_empty_contents?
      generic_files.any? {|gf| gf.with_empty_content?}
    end

  # for generic file submission form... "xxxxx is preferred"
    def preferred_file_format
      'A PDF copy'
    end
  end
end
