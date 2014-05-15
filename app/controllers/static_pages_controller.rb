class StaticPagesController < ApplicationController
  with_themed_layout '1_column'
  respond_to(:html)

  def about
  end

  def beta
  end
end
