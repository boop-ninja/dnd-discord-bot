require_relative 'embedded'

module R4RBot
  module Mocks
    class Channel < MiniTest::Mock
      def initialize(delegator = nil)
        super(delegator)
      end

      def send_embed(title)
        embed = R4RBot::Mocks::Embedded.new
        yield embed
        embed.fields
      end
    end
  end
end