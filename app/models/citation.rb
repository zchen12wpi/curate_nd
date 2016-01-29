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
                show_page = common_object_url(curation_concern.noid, host:Rails.configuration.application_root_url)
                md = {
                  id: curation_concern.noid,
                  URL: show_page,
                  source: show_page,
                  title: curation_concern.title,
                }
                v = date_created
                md[:issued] = v if v.present?
                v = creator
                md[:author] = v if v.present?
                v = publisher
                md[:publisher] = v if v.present?
                v = doi
                md[:DOI] = v if v.present?
                CiteProc::Item.new(md)
              end
  end

  def doi
    v = try_fields([:doi, :identifier])
    return nil if v.nil?
    # try to only keep dois
    v = v.select { |id| id =~ /\A[^0-9]*?10\./ }
    # remove any doi: prefixes
    v.sub(/\A.*?10/, "10")
  end

  def date_created
    v = try_fields([:date_created, :created])
    return nil if v.nil?
    begin
      Date.parse(v)
    rescue ArgumentError
      # invalid date string
    end
  end

  def creator
    v = try_fields([:creator])
    return nil if v.nil?
    v.join(" and ")
  end

  def publisher
    v = try_fields([:publisher])
    return nil if v.nil?
    v.join(", ")
  end

  def try_fields(fields)
    fields.each do |field|
      if curation_concern.respond_to?(field)
        return curation_concern.send(field)
      end
    end
    nil
  end
end

