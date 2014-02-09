module Txt
  module Routing
    class Base
      class << self
        def route(command, options = {})
          check_options(options)

          @route_table ||= []
          @route_table << Routing::Route.new(command, options)
        end

        def default(options = {})
          check_options(options)

          @route_table ||= []
          @route_table << Routing::Route.new(nil, options)
        end

        def match(options)
          command, number, message = command_number_and_message(options)
          route   = @route_table.find { |r| r.match?(command) }

          route.call(number, message)
        end

        private
        def check_options(options)
          raise "All routes need a controller and an action to be valid." unless options[:controller] && options[:action]
        end

        def command_number_and_message(options)
          message, number = options.values_at("Body", "From")

          message_array = message.to_s.split(" ")
          command = message_array.shift.upcase.gsub(/(\!|\,\.\?)+/, "")
          message = message_array.join(" ")

          return [command, number, message]
        end
      end
    end

    class Route
      attr_reader :command, :controller, :action

      def initialize(command, options = {})
        @command = command

        @controller = options[:controller]
        @action     = options[:action]
      end

      def match?(command)
        (self.command == command) || self.command.nil?
      end

      def call(number, message)
        controller = klass.new(number, action, message)
        controller.perform
      end

      private
      def klass
        "#{controller.to_s.camelcase}Controller".constantize
      end
    end
  end
end
