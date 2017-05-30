# Responsible for generating the JSON-LD results from a Blacklight search response
class CatalogIndexJsonldPresenter
  CONTEXT = {
    'xsd' => "http://www.w3.org/2001/XMLSchema#".freeze,
    'deri' => "http://sindice.com/vocab/search#".freeze,
    'und' => File.join(Rails.configuration.application_root_url, 'show/').freeze,
    'dc' => 'http://purl.org/dc/terms/'.freeze,
    'deri:first' => { '@type' => '@id' },
    'deri:last' => { '@type' => '@id' },
    'deri:previous' => { '@type' => '@id' },
    'deri:next' => { '@type' => '@id' },
    'deri:itemsPerPage' => { '@type' => 'xsd:integer' },
    'deri:totalResults' => { '@type' => 'xsd:integer' }
  }
  attr_reader :raw_response, :request_url, :documents, :pager, :query_parameters

  def initialize(raw_response, request_url, query_parameters)
    @raw_response = raw_response
    @request_url = RDF::URI.new(request_url)
    @documents = raw_response.fetch('response').fetch('docs')
    @query_parameters = query_parameters
    @pager = Pager.new(self)
    build_jsonld!
  end
  delegate :total_results, :start, :items_per_page, to: :pager

  # @return [String] the JSON document
  def to_jsonld
    JSON.dump(@jsonld)
  end

  # @return [Hash] a Ruby Hash of the JSON document
  def as_jsonld
    @jsonld
  end

  private

  def build_jsonld!
    jsonld = { "@context" => CONTEXT, "@graph" => [] }
    add_pagination_to_graph(jsonld)
    add_documents_to_graph(jsonld)
    @jsonld = jsonld
  end

  def add_pagination_to_graph(jsonld)
    pagination_object = {
      '@id' => request_url.to_s,
      'deri:itemsPerPage' => items_per_page,
      'deri:totalResults' => total_results,
    }
    [:first, :last, :previous, :next].each do |pagination_method|
      pager.pagination_url_for(pagination_method) do |url|
        pagination_object["deri:#{pagination_method}"] = url.to_s
      end
    end
    jsonld['@graph'] << pagination_object
  end

  def add_documents_to_graph(jsonld)
    documents.each do |document|
      dc_title = Array.wrap(document.fetch('desc_metadata__title_tesim', 'title-not-found' )).first
      document_object = {
        "@id" => document.fetch('id'),
        "dc:title" => dc_title
      }
      jsonld['@graph'] << document_object
    end
  end

  class Pager
    def initialize(presenter)
      @presenter = presenter
      @total_results = raw_response.fetch('response').fetch('numFound').to_i
      @start = raw_response.fetch('response').fetch('start').to_i
      @items_per_page = raw_response.fetch('responseHeader').fetch('params').fetch('rows').to_i
      @page = query_parameters.fetch('page', 1).to_i
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
      return 1 if total_results == 0
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
        if total_pages == 1
          build_pagination_url(query_parameters.except('page'))
        else
          build_pagination_url(query_parameters.merge('page' => total_pages))
        end
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
