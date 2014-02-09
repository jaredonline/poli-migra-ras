class TwiliosController < ApplicationController
  def create
    # Massage the phone number
    params["From"] = (params["From"][0..1] == "+1") ? params["From"][2...params["From"].length] : params["From"]

    result = Drip::Routing::Table.match(params)

    render :text => result
  end
end

