# frozen_string_literal: true

require_relative '../utils/command'
require_relative '../utils/normalize_content'
require_relative '../utils/quick_maths'

module R4RBot
  module Commands
    class Roll < Command
      def self.keyword
        'roll'
      end

      def valid_die?(die_size)
        [4, 6, 8, 10, 12, 20].include?(die_size.to_i)
      end

      def parse_message_components(content)
        {
          count: content[/^\d+/],
          die_size: content[/d(\d+)/, 1],
          math_symbol: content[%r{([\\/\+\*])}, 1] || '+',
          modifier: content[/\W(\d+)/, 1] || '0',
          description: content[/\s(.*)$/, 1] || 'You made a roll!!'
        }
      end

      # @param [Discordrb::Events::MessageEventHandler] event
      def fulfill(event)
        log_msg = format(
          'Received roll request from %<username>s',
          username: event.user.nick || event.user.username
        )
        logger.info(log_msg)
        count, die_size, math_symbol, modifier, description =
          parse_message_components(normalize_content(event.content)).values
        query = [count, 'd', die_size]
        query.concat([math_symbol, modifier]) if modifier.to_i.positive?
        rolls = Array.new(count.to_i) { |_i| (1..die_size.to_i).to_a.sample }
        sum = quick_maths math_symbol, rolls.inject(:+), modifier
        event.channel.send_embed('') do |embed|
          embed.title = description.sub(/\<[\@\!]\d*\>/, 'player')
          embed.description = 'Lets see them rolls bb!'
          embed.colour = rolls.include?(1) ? 0xff1900 : 0x3cff00
          embed.add_field(name: 'Query:', value: format('%<query>s', query: query.join('')))
          embed.add_field(name: 'Rolls:', value: format('%<rolls>s', rolls: rolls.join(', ')))
          embed.add_field(name: 'Sum:', value: format('%<sum>d', sum: sum))
        end
      end
    end
  end
end

