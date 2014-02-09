module Txt
  module Controller
    class Base
      attr_reader :number, :command, :message

      def initialize(number, command, message = nil)
        @number   = number
        @command  = command
        @message  = message
        @response = Response::Base.new
      end

      def perform
        if respond_to?(command)
          __send__(command)
        else
          four_oh_four
        end

        response
      end

      def four_oh_four
        "Blah blah blah"
      end

      private
      attr_reader :response

      def no_response
        response.no_response
      end

      def response_message(message)
        twiml = Twilio::TwiML::Response.new do |r|
          r.Sms message
        end
        puts "setting message: #{twiml.text}"
        response.message = twiml.text
      end
    end
  end

  module Response
    class Base
      attr_accessor :message, :should_respond

      def initialize
        self.should_respond = true
      end

      def should_respond?
        self.should_respond
      end

      def no_response
        self.should_respond = false
      end
    end
  end
end
