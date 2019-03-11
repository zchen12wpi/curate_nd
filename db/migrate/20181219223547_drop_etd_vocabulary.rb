class DropEtdVocabulary < ActiveRecord::Migration
  def change
    drop_table :etd_vocabularies
  end
end
