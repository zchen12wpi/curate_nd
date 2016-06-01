module Bendo
  # Pass file cache status requests along to Bendo
  class FileCacheStatusController < BendoController
    def check
      render :json => Bendo::Services::FileCacheStatus.call(
        id: params[:id],
        handler: Bendo::Services::FileCacheStatus::FakeApi
      )
    end
  end
end
