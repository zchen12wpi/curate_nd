class Admin::MasqueradesController < Devise::MasqueradesController

  def back
    super
    flash[:alert] = "Masquerade stopped. You are now acting as yourself."
  end

  private

  def after_back_masquerade_path_for(resource)
    '/'
  end

end
