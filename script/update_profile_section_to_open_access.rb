module UpdateProfileSectionToOpenAccess
  module_function
  def run
    ProfileSection.all.each do |section|
      unless section.visibility == "open"
        section.set_visibility_to_open_access
        section.save!
      end
    end
  end
end
UpdateProfileSectionToOpenAccess.run
