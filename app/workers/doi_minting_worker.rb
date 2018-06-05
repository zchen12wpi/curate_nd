# The purpose of this class is to mint doi.
# This is an assynchronous process.

class DoiMintingWorker
  class PidError < RuntimeError
    def initialize(url_string)
      super(url_string)
    end
  end

  def queue_name
    :doi_miniting_requests
  end

  attr_reader :pid

  def initialize(pid)
    if pid.blank?
      raise PidError.new("PID required for DOI creation.")
    end
    @pid = pid
  end

  def run
    obj = ActiveFedora::Base.find( pid, cast: true )
    obj.identifier = Doi::Datacite.mint(obj)
    obj.save
  end
end
