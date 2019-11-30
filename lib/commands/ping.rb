# frozen_string_literal: true

require_relative '../utils/command'

module R4RBot
  module Commands
    class Ping < Command
      def self.keyword
        'ping'
      end
      # @param [Discordrb::Events::MessageEventHandler] event
      def fulfill(event, user_ids)
        logger.info "Received ping request from #{event.user.nick || event.user.username}"
        m = event.respond 'pong!'
        m.edit format('pong! - event delay %0.3f seconds.', Time.now - event.timestamp)
      end
    end
  end
end