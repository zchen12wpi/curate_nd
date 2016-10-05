class AlephIdentifierValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    if value.present?
      value.each do |ai|
        if ai.strip!
          record.errors[attribute] << 'Cannot have leading or trailing spaces'
        else
          # AlephIdentifier number are only 9 digits.
          unless ai =~ /\A\d{9}\z/
            record.errors[attribute] << 'Invalid Aleph Identifier Number'
          end
        end
      end
    end
  end

end
