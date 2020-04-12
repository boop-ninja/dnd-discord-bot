require_relative 'channel'
require_relative 'user'

module R4RBot
  module Mocks
    class Event < MiniTest::Mock
      def initialize(content:)
        super(nil)
        @content = content

      end
      attr_accessor :content

      def channel
        @channel ||= R4RBot::Mocks::Channel.new
      end

      def user
        @user ||= R4RBot::Mocks::User.new
      end
    end
  end
end