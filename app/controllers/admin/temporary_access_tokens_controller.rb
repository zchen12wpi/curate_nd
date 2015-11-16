class Admin::TemporaryAccessTokensController < ApplicationController
  with_themed_layout('1_column')

  before_action :set_temporary_access_token, only: [:show, :edit, :update, :destroy]

  # GET /temporary_access_tokens
  def index
    @temporary_access_tokens = TemporaryAccessToken.all
  end

  # GET /temporary_access_tokens/1
  def show
  end

  # GET /temporary_access_tokens/new
  def new
    @temporary_access_token = TemporaryAccessToken.new
  end

  # GET /temporary_access_tokens/1/edit
  def edit
  end

  # POST /temporary_access_tokens
  def create
    @temporary_access_token = TemporaryAccessToken.new(temporary_access_token_params)

    if @temporary_access_token.save
      redirect_to @temporary_access_token, notice: 'Temporary access token was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /temporary_access_tokens/1
  def update
    if @temporary_access_token.update(temporary_access_token_params)
      redirect_to @temporary_access_token, notice: 'Temporary access token was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /temporary_access_tokens/1
  def destroy
    @temporary_access_token.destroy
    redirect_to temporary_access_tokens_url, notice: 'Temporary access token was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_temporary_access_token
      @temporary_access_token = TemporaryAccessToken.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def temporary_access_token_params
      params.require(:temporary_access_token).permit(:noid, :issued_by)
    end
end
