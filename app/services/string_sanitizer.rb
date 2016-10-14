class StringSanitizer
  attr_accessor :string

  def initialize(string)
    @string = string
  end

  def sanitize
    string
  end
end
