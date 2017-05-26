# Responsible for generating the JSON-LD results from a Blacklight search response
class CatalogIndexJsonldPresenter
  CONTEXT = {
    deri: "http://sindice.com/vocab/search#".freeze,
    und: File.join(Rails.configuration.application_root_url, 'show/').freeze,
    dc: 'http://purl.org/dc/terms/'.freeze
  }
  attr_reader :raw_response, :request_url, :documents, :graph, :pager, :query_parameters

  def initialize(raw_response, request_url, query_parameters, graph: default_graph)
    @raw_response = raw_response
    @request_url = RDF::URI.new(request_url)
    @documents = raw_response.fetch('response').fetch('docs')
    @query_parameters = query_parameters
    @pager = Pager.new(self)
    @graph = graph
  end
  delegate :total_results, :start, :items_per_page, to: :pager

  # @return [String] the JSON document
  def to_jsonld
    add_elements_to_graph
    transform_graph_to_jsonld
  end

  # @return [Hash] a Ruby Hash of the JSON document
  def as_jsonld
    JSON.parse(to_jsonld)
  end

  private

  def add_elements_to_graph
    add_pagination_to_graph
    add_documents_to_graph
  end

  def add_pagination_to_graph
    graph << RDF::Statement.new(request_url, 'deri:itemsPerPage', items_per_page)
    graph << RDF::Statement.new(request_url, 'deri:totalResults', total_results)
    [:first, :last, :previous, :next].each do |pagination_method|
      pager.pagination_url_for(pagination_method) do |url|
        graph << RDF::Statement.new(request_url, "deri:#{pagination_method}", url)
      end
    end
  end

  def add_documents_to_graph
    documents.each do |document|
      document_uri = RDF::URI.new(document.fetch("id"))
      graph << RDF::Statement.new(request_url, 'deri:result', document_uri)
      dc_title = document.fetch('desc_metadata__title_tesim').first
      graph << RDF::Statement.new(document_uri, 'dc:title', dc_title)
    end
  end

  def transform_graph_to_jsonld
    JSON::LD::Writer.buffer(prefixes: CONTEXT) do |writer|
      graph.each_statement do |statement|
      writer << statement
      end
    end
  end

  def default_graph
    RDF::Graph.new
  end

  class Pager
    def initialize(presenter)
      @presenter = presenter
      @total_results = raw_response.fetch('response').fetch('numFound').to_i
      @start = raw_response.fetch('response').fetch('start')
      @items_per_page = raw_response.fetch('responseHeader').fetch('params').fetch('rows').to_i
      @page = query_parameters.fetch('page', 1)
      @request_url_without_params = File.join(request_url.root.to_s, request_url.path)
    end
    attr_reader :presenter, :total_results, :start, :items_per_page, :page, :request_url_without_params
    delegate :query_parameters, :raw_response, :request_url, to: :presenter

    def next_page
      return nil if last_page?
      page + 1
    end

    def prev_page
      return nil if first_page?
      page - 1
    end

    def last_page?
      total_pages == page
    end

    def total_pages
      (total_results / items_per_page.to_f).ceil
    end

    def first_page?
      page == 1
    end

    def pagination_url_for(pagination_method)
      case pagination_method
      when :previous
        return false if first_page?
      when :next
        return false if last_page?
      end
      pagination_url = __pagination_url_for(pagination_method)
      yield(pagination_url) if block_given?
      return pagination_url
    end

    private

    def __pagination_url_for(pagination_method)
      case pagination_method
      when :next
        return nil if last_page?
        build_pagination_url(query_parameters.merge('page' => next_page))
      when :previous
        return nil if first_page?
        build_pagination_url(query_parameters.merge('page' => prev_page))
      when :last
        build_pagination_url(query_parameters.merge('page' => total_pages))
      when :first then
        build_pagination_url(query_parameters.except('page'))
      end
    end

    def build_pagination_url(query_parameters)
      return request_url_without_params if query_parameters.empty?
      "#{request_url_without_params}?#{query_parameters.to_query}"
    end
  end
end
