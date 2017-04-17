module CurationConcern
  module WithCollaborators
    extend ActiveSupport::Concern

    included do
      has_and_belongs_to_many :record_editors, class_name: "::Person", property: :has_editor
      accepts_nested_attributes_for :record_editors, allow_destroy: true, reject_if: :all_blank
      has_and_belongs_to_many :record_editor_groups, class_name: "::Hydramata::Group", property: :has_editor_group
      accepts_nested_attributes_for :record_editor_groups, allow_destroy: true, reject_if: :all_blank

      has_and_belongs_to_many :record_viewers, class_name: "::Person", property: :has_viewer
      accepts_nested_attributes_for :record_viewers, allow_destroy: true, reject_if: :all_blank
      has_and_belongs_to_many :record_viewer_groups, class_name: "::Hydramata::Group", property: :has_viewer_group
      accepts_nested_attributes_for :record_viewer_groups, allow_destroy: true, reject_if: :all_blank
    end

    SOLR_KEY_EDITOR_PIDS = ActiveFedora::SolrService.solr_name(:record_editors).freeze
    SOLR_KEY_EDITOR_GROUP_PIDS = ActiveFedora::SolrService.solr_name(:record_editor_groups).freeze
    SOLR_KEY_VIEWER_PIDS = ActiveFedora::SolrService.solr_name(:record_viewers).freeze
    SOLR_KEY_VIEWER_GROUP_PIDS = ActiveFedora::SolrService.solr_name(:record_viewer_groups).freeze


    # TODO Need Curate::EditorIndexingAdapter.write_document_attributes_to_index_layer?
    def to_solr(solr_doc={}, opts={})
      super(solr_doc, opts)
      solr_doc[SOLR_KEY_EDITOR_PIDS] = self.record_editor_ids
      solr_doc[SOLR_KEY_EDITOR_GROUP_PIDS] = self.record_editor_group_ids
      solr_doc[SOLR_KEY_VIEWER_PIDS] = self.record_viewer_ids
      solr_doc[SOLR_KEY_VIEWER_GROUP_PIDS] = self.record_viewer_group_ids
      solr_doc
    end


    def update_index
      super
      #TODO Check if there need to be indexer module
      Curate.relationship_reindexer.call(self.pid)
    end
  end
end
