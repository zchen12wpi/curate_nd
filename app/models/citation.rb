require 'citeproc'
require 'csl/styles'

class Citation
  include Rails.application.routes.url_helpers

  # maps our internal name to the citeproc style name
  STYLES = {
    apa: "apa",
    mla: "modern-language-association-with-url",
    chicago: "chicago-fullnote-bibliography",
    harvard: "harvard1",
    vancouver: "vancouver"
  }

  attr_reader :curation_concern

  def initialize(curation_concern)
    @curation_concern = curation_concern
  end

  # The view code expects this to return an APA citation
  def to_s
    make_citation(:apa)
  end

  # return html formatted citation in the given style
  def make_citation(style)
    cp_style = STYLES[style]
    cp = CiteProc::Processor.new(style: cp_style, format:'html')
    cp.engine.format = 'html'
    cp << item
    result = cp.render(:bibliography, id: item.id, format: 'html')
    # for some reason render returns a list
    result.first
  end

  private

  # the item information we pass to citeproc
  def item
    @item ||= begin
                md = {
                  id: curation_concern.noid,
                  URL: common_object_url(curation_concern.noid, host:Rails.configuration.application_root_url),
                  source: common_object_url(curation_concern.noid, host:Rails.configuration.application_root_url),
                  title: curation_concern.title,
                }
                if curation_concern.created
                  begin
                    md[:issued] = Date.parse(curation_concern.created)
                  rescue ArgumentError
                  end
                end
                if curation_concern.creator && curation_concern.creator.length > 0
                  md[:author] = curation_concern.creator.join(" and ")
                end
                if curation_concern.publisher && curation_concern.publisher.length > 0
                  md[:publisher] = curation_concern.publisher.join(", ")
                end
                if doi.present?
                  md[:DOI] = doi
                end
                CiteProc::Item.new(md)
              end
  end

  def doi
    if curation_concern.identifier
      curation_concern.identifier.sub(/\A.*?10/, "10")
    end
  end
end

