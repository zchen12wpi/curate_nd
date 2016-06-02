module Bendo
  # Pass file cache status requests along to Bendo
  class FileCacheStatusController < BendoController
    layout false
    respond_to :json

    def check
      render :json => Bendo::Services::FileCacheStatus.call(
        id: params[:id],
        handler: Bendo::Services::FakeApi
      )
    end
  end
end
