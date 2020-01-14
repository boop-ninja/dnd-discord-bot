# frozen_string_literal: true

require_relative '../utils/command'

module R4RBot
  module Commands
    class Ping < Command
      def self.keyword
        'ping'
      end

      def send_help(event)
        event.channel.send_embed('') do |embed|
          embed.title = "#{self.class.keyword.capitalize} Command"
          embed.description = 'Gives you feedback to how fast the bot is responding.'
          embed.colour = random_hex_color
          embed.add_field(name: 'Usage', value: '!ping')
        end
      end

      # @param [Discordrb::Events::MessageEventHandler] event
      def fulfill(event)
        logger.info "Received ping request from #{event.user.nick || event.user.username}"
        m = event.respond 'pong!'
        m.edit format('pong! - event delay %0.3f seconds.', Time.now - event.timestamp)
      end
    end
  end
end