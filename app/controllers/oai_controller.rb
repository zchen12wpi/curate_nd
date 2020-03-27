class OaiController < CatalogController
  def index
    provider = OaiProvider.new
    response = provider.process_request(oai_params.to_h)
    render body: response, content_type: "text/xml"
  end

  private

  def oai_params
    params.permit(:verb, :identifier, :metadataPrefix, :set, :from, :until, :resumptionToken)
  end


      # Need to figure out where to implement this search
      # def load_data
      #   (@response, @document_list) = @controller.get_search_results
      #   Api::ItemsSearchPresenter.new(@response, @controller.request.url, @controller.request.query_parameters)
      # end
end
