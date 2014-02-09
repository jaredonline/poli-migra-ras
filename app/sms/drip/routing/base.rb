module Drip
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
          message, number = options.values_at("Body", "From")

          command = message.to_s.upcase.split(" ").first.gsub(/(\!|\,\.\?)+/, "")
          route   = @route_table.find { |r| r.match?(command) }

          route.call(number)
        end

        private
        def check_options(options)
          raise "Your need a fucking controller and action in your routes!" unless options[:controller] && options[:action]
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
        (@command == command) || @command.nil?
      end

      def call(number)
        klass = "#{controller.to_s.camelcase}Controller".constantize
        klass.perform(action, number)
      end
    end
  end
end
