require 'faker'

module R4RBot
  module Mocks
    class User < MiniTest::Mock
      def initialize
        super(nil)
        @nick = nil
        @username = Faker::Internet.username
      end
      attr_reader :username, :nick
    end
  end
end