require 'spec_helper'

describe 'static page routing' do

  it "routes to correct action" do
    expect(
        get: "/500"
    ).to route_to(controller: "static_pages", action: "error")
    expect(
        get: "/502"
    ).to route_to(controller: "static_pages", action: "error", default:{"status_code"=>"502"})
    expect(
        get: "/404"
    ).to route_to(controller: "static_pages", action: "error", default:{"status_code"=>"404"})
    expect(
        get: "/413"
    ).to route_to(controller: "static_pages", action: "error", default:{"status_code"=>"413"})
  end

end
