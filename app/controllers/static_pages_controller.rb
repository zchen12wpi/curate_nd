class StaticPagesController < ApplicationController
  with_themed_layout '1_column'
  respond_to(:html)

  def status
   @status ||= params[:status_code] || request.path.gsub('/','').to_i
  end

  helper_method :status

  def about
    render layout: 'curate_nd_home'
  end

  def home
    render layout: 'curate_nd_home'
  end

  def error
    @help_request = build_help_request
    respond_with(@help_request) do |wants|
      wants.html { render status: status }
      wants.json { render status: status }
    end
  end

  def faqs
  end

  def policies
    if params[:policyname]
      render 'policies-' + params[:policyname].to_s
    else
      render 'policies'
    end
  end

  private

  def build_help_request
    HelpRequest.new(
      user: current_user,
      how_can_we_help_you:"#{t('sufia.product_name')} encountered a problem (Error ##{status})."
    )
  end

  def show_site_search?
    if params[:action] == 'home'
      false
    else
      true
    end
  end

end
