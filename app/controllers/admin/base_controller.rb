class Admin::BaseController < ApplicationController
  include CurateND::IsAnAdminController
  with_themed_layout '1_column'
  def index
  end
end