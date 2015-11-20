class Admin::TemporaryAccessTokensController < ApplicationController
  with_themed_layout('1_column')

  before_action :set_temporary_access_token, only: [:show, :edit, :update, :destroy]

  def index
    @temporary_access_tokens = TemporaryAccessToken.order(updated_at: :desc).page(params[:page])
  end

  def show
  end

  def new
    @temporary_access_token = TemporaryAccessToken.new(new_temporary_access_token_params)
  end

  def edit
  end

  def create
    @temporary_access_token = TemporaryAccessToken.new(temporary_access_token_params_with_current_user)

    if @temporary_access_token.save
      redirect_to admin_temporary_access_token_path(@temporary_access_token), notice: 'Temporary access token was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @temporary_access_token.update(temporary_access_token_params_with_current_user)
      redirect_to admin_temporary_access_token_path(@temporary_access_token), notice: 'Temporary access token was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @temporary_access_token.destroy
    redirect_to admin_temporary_access_tokens_url, notice: 'Temporary access token was successfully destroyed.'
  end

  private

  def set_temporary_access_token
    @temporary_access_token = TemporaryAccessToken.find(params[:id])
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
end
