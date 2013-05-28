class Citation
  def initialize(curation_concern)
    @curation_concern = curation_concern
  end

  def to_s
    to_apa
  end

  def to_apa
    authors_in_apa + published_date_in_apa + @curation_concern.title + ". " + publishers_in_apa + ". " + @curation_concern.identifier
  end

  def authors
    @curation_concern.authors_for_citation
  end

  private

  def authors_in_apa
    authors_list = ""
    if authors.size == 1
      authors_list += name_format(authors.first)
    elsif authors.size >= 2
      authors.each_with_index do |name, index|
        if index == 0
          authors_list += name_format(name)
        else
          if(index == authors.size - 1)
            authors_list += ", & " + name_format(name)
          else
            authors_list += ", " + name_format(name)
          end
        end
      end
    end
    authors_list
  end

  def name_format(name)
    normalized_name = Namae.parse(name).first
    "#{normalized_name.family}, #{given_name_in_apa(normalized_name.given)}"
  end

  def given_name_in_apa(name)
    initials_arr = name.split(" ").collect {|x| x.first}
    initials = ""
    initials_arr.each do |initial|
      initials << initial + "."
    end
    initials
  end

  def published_date_in_apa
    if @curation_concern.created.blank?
      return " "
    end
    date_arr = @curation_concern.created.split("-")
    date = "(#{date_arr.first}"
    date += ", #{I18n.t("date.month_names")[date_arr[1].to_i]}"
    date += " #{date_arr.last}"
    date += "). "
  end

  def publishers_in_apa
    if @curation_concern.publisher.size == 1
      return @curation_concern.publisher.first
    end
    publishers = ""
    @curation_concern.publisher.each_with_index do |pblisher, index|
      if index == (@curation_concern.publisher.size - 1)
        publishers += pblisher
      else
        publishers += pblisher + ", "
      end
    end
    publishers
  end

end

