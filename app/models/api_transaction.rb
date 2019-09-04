class ApiTransaction < ActiveRecord::Base
  self.primary_key = 'trx_id'
  belongs_to :user
  validates_presence_of :user_id
  validates_uniqueness_of :trx_id
  has_many :api_transaction_files, foreign_key: :trx_id, dependent: :destroy

  def self.new_trx_id
    # use whatever method is desired here to set a trx id
    loop do
      trx_id = SecureRandom.hex(8)
      break trx_id unless ApiTransaction.where(trx_id: trx_id).exists?
    end
  end

  def self.set_status(status)
    case status
    when :new
      'new_transaction'
    when :update
      'transaction_updated'
    when :commit
      'submitted_for_ingest'
    when :complete
      'ingest_complete'
    when :error
      'error_during_ingest'
    else
      nil
    end
  end
end
