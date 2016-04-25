class IsbnValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    if value.present?
      value.each do |isbn|
        if isbn.strip!
          record.errors[attribute] << 'Cannot have leading or trailing spaces'
        elsif (isbn[0] == '-' || isbn[-1] == '-')
          record.errors[attribute] << 'Cannot have leading or trailing hyphens'
        else
          # There can be an arbitrary number of dash seperators
          isbn.delete!('-')
          # ISBN number can be 10 or 13 digits. The last "digit" can be an "X".
          unless isbn =~ /\A(?=[0-9]*)(?:.{9}|.{12})[\dx]\z/i
            record.errors[attribute] << 'Invalid ISBN'
          end
        end
      end
    end
  end

end
