class BrewsController
  class << self
    def new(number)
      @coffee_trip = CoffeeTrip.new
      @coffee_trip.add_crafter(@user)
      @coffee_trip.save

      response_message "Coffeez brewin'!"
    end

    def subscribe(number)
      @coffee_trip = CoffeeTrip.order("created_at DESC").first
      @coffee_trip.reserve(@user)
      @coffee_trip.reload

      if @user.in?(@coffee_trip.winners)
        @coffee_trip.crafter.send_message("#{@user.name} is now your junky!")
        response_message "You're on the list, Junky!"
      else
        response_message "You're too slow! You didn't make it Junky."
      end
    end

    def help(number)
      response_message <<-MESSAGE
      To brew a Chemex you should use 72 grams of coffee, coarsely ground, and 1065 grams
      of water.
      MESSAGE
    end

    def finish(number)
      @coffee_trip = CoffeeTrip.order("created_at DESC").first

      if @coffee_trip.crafter == @user
        @coffee_trip.brewed!
        response_message "'Bout time! Your junkies are #{@coffee_trip.junky_names}"
      else
        four_oh_four(number)
      end
    end

    def four_oh_four(number)
      response_message "Hey Monkey, you can't do that!"
    end

    def perform(action, number)
      @user = User.find_by_phone_number(number)

      if @user
        __send__(action, number)
      else
        four_oh_four(number)
      end
    end

    private
    def response_message(message)
      twiml = Twilio::TwiML::Response.new do |r|
        r.Sms message
      end
      twiml.text
    end
  end
end

