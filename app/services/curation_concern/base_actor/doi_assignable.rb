module CurationConcern::BaseActor::DoiAssignable

  def create!
    super
    assign_doi_if_applicable
  end

  def update!
    super
    assign_doi_if_applicable
  end

  def assign_doi_if_applicable
    if attributes[:assign_doi].to_i != 0
      doi_minter.call(curation_concern.pid)
    end
  end

  include Morphine
  register :doi_minter do
    lambda { |pid|
      Sufia.queue.push(DoiWorker.new(pid))
    }
  end

end
