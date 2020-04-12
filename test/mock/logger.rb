module R4RBot
  module Mocks
    class Logger < Minitest::Mock
      def self.info(*args)
        nil
      end
      def self.warn(*args)
        nil
      end
      def self.error(*args)
        nil
      end
    end
  end
end