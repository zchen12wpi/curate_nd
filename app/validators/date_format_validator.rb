class DateFormatValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    if value.present?
      begin
        if value.to_date.is_a?(Date) == false
          record.errors[attribute] << "Invalid Date Format"
        end
      rescue ArgumentError, NoMethodError => e
        record.errors[attribute] << "Invalid Date Format"
      end
    end
  end

end
