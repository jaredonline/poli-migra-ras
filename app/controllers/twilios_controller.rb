class TwiliosController < ActionController::API
  def create
    result = SmsRouter.match(twilio_params)

    if result.should_respond?
      render :text => result
    end
  end

  private
  def twilio_params
    # Massage the phone number
    params["From"] = (params["From"][0..1] == "+1") ? params["From"][2...params["From"].length] : params["From"]
    params.require("From", "Body")
  end
end

