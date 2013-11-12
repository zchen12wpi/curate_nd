class Admin::UserWhitelistsController < ApplicationController
  include CurateND::IsAnAdminController
  with_themed_layout('1_column')

  before_action :set_admin_user_whitelist, only: [:show, :edit, :update, :destroy]

  # GET /admin/user_whitelists
  def index
    @admin_user_whitelists = Admin::UserWhitelist.all.page(params[:page])
  end

  # GET /admin/user_whitelists/1
  def show
  end

  # GET /admin/user_whitelists/new
  def new
    @admin_user_whitelist = Admin::UserWhitelist.new
  end

  # GET /admin/user_whitelists/1/edit
  def edit
  end

  # POST /admin/user_whitelists
  def create
    @admin_user_whitelist = Admin::UserWhitelist.new(admin_user_whitelist_params)

    if @admin_user_whitelist.save
      redirect_to @admin_user_whitelist, notice: 'User whitelist was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /admin/user_whitelists/1
  def update
    if @admin_user_whitelist.update(admin_user_whitelist_params)
      redirect_to @admin_user_whitelist, notice: 'User whitelist was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /admin/user_whitelists/1
  def destroy
    @admin_user_whitelist.destroy
    redirect_to admin_user_whitelists_url, notice: 'User whitelist was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_user_whitelist
      @admin_user_whitelist = Admin::UserWhitelist.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def admin_user_whitelist_params
      params.require(:admin_user_whitelist).permit(:username)
    end
end
