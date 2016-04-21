class IsbnValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    if value.present?
      value.each do |isbn|
        if isbn.strip!
          record.errors[attribute] << 'Cannot have leading or trailing spaces'
        else
          unless isbn =~ /(97[89])?\-?\d\-?\d\-?\d\-?\d\-?\d\-?\d\-?\d\-?\d\-?\d\-?[\dx]/i
            record.errors[attribute] << 'Invalid ISBN'
          end
        end
      end
    end
  end

end
