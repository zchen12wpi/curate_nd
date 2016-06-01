# CurateND wraps several Bendo API calls. This class stores shared
# configuration between different request handlers.
class BendoController < ApplicationController
  layout false
  respond_to :json
end
