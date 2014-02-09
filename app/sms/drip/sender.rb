module Drip
  class Sender
    def self.send_message(message, to)
      client.account.sms.messages.create(:from => ENV["TWILIO_NUMBER"], :to => to, :body => message)
    end

    def self.client
      @client ||= Twilio::REST::Client.new ENV["TWILIO_SID"], ENV["TWILIO_AUTH_TOKEN"]
    end
  end
end
