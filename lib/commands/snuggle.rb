# frozen_string_literal: true

require_relative '../utils/command'
require_relative '../utils/format_user_id'
require_relative '../utils/random_hex_color'

module R4RBot
  module Commands
    class Snuggle < Command
      def self.keyword
        'snuggle'
      end

      # @param [Discordrb::Events::MessageEventHandler] event
      def fulfill(event)
        user_ids = parse_user_ids(event.message.content)
        log_msg = format(
          'Received snuggle request from %<username>s',
          username: event.user.nick || event.user.username
        )
        logger.info(log_msg)
        user_id, *_other_ids = user_ids
        opts = {
          author_id: format_user_id(event.author.id),
          recipient: format_user_id(user_id)
        }
        if opts[:author_id] == opts[:recipient]
          m = event.respond 'yikes'
          m.edit format('I guess %<author_id>s is just in love with themselves..', opts)
        elsif !user_ids.empty?
          event.channel.send_embed('') do |embed|
            embed.title = 'Snuggle mode active!'
            embed.description = 'Snuggle bomb incoming!!!!'
            embed.colour = random_hex_color
            embed.add_field(name: 'Snuggles From:', value: format('%<author_id>s', opts))
            embed.add_field(name: 'Snuggles To:', value: format('%<recipient>s', opts))
            embed.add_field(
              name: 'Kabooooom',
              value: format('%<author_id>s aggressively snuggles %<recipient>s', opts)
            )
          end
        else
          m = event.respond 'yikes'
          m.edit format('%<author_id>s you snuggled no one :(', opts)
        end
      end
    end
  end
end

