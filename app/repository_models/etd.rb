require Curate::Engine.root.join('app/repository_models/etd')

class Etd
  self.human_readable_short_description = "Deposit a master's thesis or dissertation."

  def self.human_readable_type
    'Thesis or Dissertation'
  end

  def human_readable_type
    degree.map(&:level).flatten.to_sentence
  end
end
