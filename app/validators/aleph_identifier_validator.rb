class AlephIdentifierValidator < ActiveModel::EachValidator
  WHITESPACE_ERROR_MESSAGE = 'Cannot have leading or trailing spaces'.freeze
  FORMAT_ERROR_MESSAGE = 'Aleph Identifier must be 9 digits. Left pad with zeros if needed.'.freeze

  def validate_each(record, attribute, value)
    if value.present?
      value.each do |ai|
        if ai.strip!
          record.errors[attribute] << WHITESPACE_ERROR_MESSAGE
        else

          # AlephIdentifier number are only 9 digits.
          unless ai =~ /\A\d{9}\z/
            record.errors[attribute] << FORMAT_ERROR_MESSAGE
          end
        end
      end
    end
  end

end
