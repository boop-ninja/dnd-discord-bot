module R4RBot
  module Mocks
    class Embedded < Minitest::Mock
      def initialize(delegator = nil)
        super(delegator)
        @fields = []
        @title = ''
        @description = ''
        @colour = ''
      end

      attr_accessor :title, :description, :colour
      attr_reader :fields

      def add_field(name:, value:, inline: false)
        @fields.push({name: name, value: value, inline: inline})
      end

    end
  end
end