require 'uri'
require 'net/http'

# use library api to query active directory
class Adnd::ActivedirectoryController < ApplicationController

  # GET /adnd/namelist/:id
  def namelist
    adnd_url_base = ENV.fetch['AD_API_URL']
    adnd_token = ENV.fetch['AD_API_TOKEN]
    url = URI("#{'adnd_url_base'}#{params[:id]}.json?auth_token=#{adnd_token}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)

    render json:  http.request(request).read_body
  end
end
