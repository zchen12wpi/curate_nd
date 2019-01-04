class Admin::TemporaryAccessTokensController < ApplicationController
  with_themed_layout('1_column')

  before_action :set_temporary_access_token, only: [:show, :edit, :update, :destroy]

  def index
    @limit_to_id = limit_to_id
    @temporary_access_tokens = temporary_access_token_list
  end

  def show
  end

  def new
    @temporary_access_token = TemporaryAccessToken.new(new_temporary_access_token_params)
    create if params.has_key? :temporary_access_token
  end

  def edit
  end

  def create
    @temporary_access_token = TemporaryAccessToken.new(temporary_access_token_params_with_current_user)
    permitted = validate_create_token

    if permitted[:valid] == true
      if @temporary_access_token.save
        redirect_to admin_temporary_access_tokens_path, notice: 'Temporary access token was successfully created.'
      else
        render action: 'new'
      end
    else
      redirect_to admin_temporary_access_tokens_path, notice: permitted[:notice]
    end
  end

  def update
    if @temporary_access_token.update(temporary_access_token_params_with_current_user)
      redirect_to admin_temporary_access_tokens_path, notice: 'Temporary access token was successfully renewed.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @temporary_access_token.destroy
    redirect_to admin_temporary_access_tokens_path, notice: 'Temporary access token was successfully deleted.'
  end

  def remove_expired_tokens
    redirect_to admin_temporary_access_tokens_path, notice: "Don't worry, nothing really happened here."
  end

  private

  def set_temporary_access_token
    @temporary_access_token ||= TemporaryAccessToken.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def temporary_access_token_params
    params.require(:temporary_access_token).permit(:noid, :issued_by, :reset_expiry_date)
  end

  # Only accept a noid during token creation
  def new_temporary_access_token_params
    if params.has_key? :temporary_access_token
      params.require(:temporary_access_token).permit(:noid)
    else
      {}
    end
  end

  # Enforce that the current user is associated with creating or modifying a token
  def temporary_access_token_params_with_current_user
    temporary_access_token_params.merge({ :issued_by => current_user.user_key })
  end

  def temporary_access_token_list
    if @limit_to_id.nil?
      TemporaryAccessToken.order(updated_at: :desc).page(params[:page])
    else
      TemporaryAccessToken.where(noid: limit_to_id).order(updated_at: :desc).page(params[:page])
    end
  end

  def limit_to_id
    limit_to_id = nil
    if params.has_key? :temporary_access_token
      if params[:temporary_access_token].has_key? :noid
        limit_to_id = params[:temporary_access_token][:noid]
      end
    end
  end

  def validate_create_token
    item_to_access = begin
      ActiveFedora::Base.load_instance_from_solr(Sufia::Noid.namespaceize(@temporary_access_token.noid))
    rescue ActiveFedora::ObjectNotFoundError
      return { test: :not_found, valid: false, notice: "Error: Unable to add access token; file #{@temporary_access_token.noid} was not found." }
    end
    # object must be a generic_file
    return { valid: false, notice: "Error: Unable to add access token; item ID is not a file." } if item_to_access.class != GenericFile
    # must be allowed to edit file or token manager
    return { valid: false, notice: "Error: Not authorized to create token for file #{@temporary_access_token.noid}." } unless (can? :edit, item_to_access) || (can? :manage, TemporaryAccessToken)
    # otherwise valid
    { valid: true, notice: nil }
  end
end
