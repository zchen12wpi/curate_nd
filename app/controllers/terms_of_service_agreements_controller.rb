class TermsOfServiceAgreementsController < ApplicationController
  I_AGREE_TEXT = "I Agree"
  respond_to(:html)
  layout 'curate_nd'
  def new
  end

  def create
    if params[:commit] == I_AGREE_TEXT
      current_user.agree_to_terms_of_service!
      redirect_to classify_path
    end
  end
end
