# frozen_string_literal: true

require_relative '../command'
require_relative '../utils/normalize_content'
require_relative '../utils/quick_maths'
require_relative '../utils/random_hex_color'
require_relative '../utils/regexes'
require_relative '../utils/hex_colors'

module R4RBot
  module Commands
    class Roll < Command
      def self.keyword
        'roll'
      end

      def dice_set_filter
        R4RBot::Utils::Regexes::Roll::DICE_FILTER
      end

      def valid_die?(die_size)
        [4, 6, 8, 10, 12, 20, 100].include?(die_size.to_i)
      end

      def send_help(event)
        event.channel.send_embed('') do |embed|
          embed.title = "#{self.class.keyword.capitalize} Command"
          embed.description = 'Rolls like a boss!'
          embed.colour = random_hex_color
          embed.add_field(name: 'Usage', value: '!roll [count]d[die size]')
          embed.add_field(
            name: 'Advanced Usage I',
            value: '!roll [count]d[die size][modifier] [note]'
          )
          embed.add_field(
            name: 'Advanced Usage II',
            value: '!roll [count]d[die size][modifier],[count]d[die size][modifier] [note]'
          )
          embed.add_field(name: 'Example', value: '!roll 1d6')
          embed.add_field(name: 'Advanced Example I', value: '!roll 1d20+2 My Initiative')
          embed.add_field(name: 'Advanced Example II', value: '!roll 4d6,4d6,4d6,4d6,4d6,4d6')
        end
      end

      def parse_dice_roll_components(content)
        c_string = content.to_s
        {
          count: c_string[dice_set_filter, 1],
          die_size: c_string[dice_set_filter, 2],
          math_symbol: c_string[dice_set_filter, 4] || '+',
          modifier: c_string[dice_set_filter, 5] || '0'
        }
      end

      def parse_roll_sets_from_message(context)
        context.to_enum(:scan, dice_set_filter)
          .map {$&}
          .map {|d| d.downcase.tr(' ', '')}
          .map {|d| parse_dice_roll_components(d)}
      end

      # @param [Object] roll_data
      def handle_dice_roll(roll_data)
        count, die_size, math_symbol, modifier = roll_data.values
        query = [count, 'd', die_size]
        query.concat([math_symbol, modifier]) if modifier.to_i.positive?
        rolls = Array.new(count.to_i) { |_i| (1..die_size.to_i).to_a.sample }
        sum = quick_maths math_symbol, rolls.inject(:+), modifier
        { query: query, rolls: rolls, sum: sum }
      end

      # @param [Object] event
      # @param [String] description
      # @param [Object] roll_data
      def respond_with_embedded_single_role(event:, description:, roll_data:)
        event.channel.send_embed('') do |embed|
          embed.title = 'Lets see them rolls bb!'
          embed.description = description
          embed.colour = roll_data[:rolls].include?(1) ? R4RBot::Utils::Colors::ERROR_RED : R4RBot::Utils::Colors::SUCCESS_GREEN
          embed.add_field(name: 'Query:', value: format('%<query>s', query: roll_data[:query].join('')))
          embed.add_field(name: 'Rolls:', value: format('%<rolls>s', rolls: roll_data[:rolls].join(', ')))
          embed.add_field(name: 'Sum:', value: format('%<sum>d', sum: roll_data[:sum]))
          embed
        end
      end

      # @param [Object] event
      # @param [String] description
      # @param [Object] roll_data
      def respond_with_embedded_multi_role(event:, description:, roll_data:)
        event.channel.send_embed('') do |embed|
          embed.title = 'Looks like you made a couple of rolls!'
          embed.description = description
          embed.colour = random_hex_color
          embed.add_field(name: 'Queries:', value: format('%<query>s', query: roll_data.map {|e| e[:query].join('')}.join(', ')))
          roll_data.each do |roll|
            embed.add_field(name: 'Query:', value: format('%<rolls>s', rolls: roll[:query].join('')))
            embed.add_field(name: 'Rolls:', value: format('%<rolls>s', rolls: roll[:rolls].join(', ')), inline: true)
            embed.add_field(name: 'Sum:', value: format('%<sum>d', sum: roll[:sum]), inline: true)
          end
          embed
        end
      end

      # @param [Discordrb::Events::MessageEventHandler] event
      def fulfill(event)
        username = event.user.nick || event.user.username
        logger.info format(
                      'Received roll request from %<username>s',
                      username: username
                    )
        description =  (event.content[R4RBot::Utils::Regexes::Roll::DESCRIPTION_MESSAGE, 1] || 'You made a roll!!').capitalize
        dice_roll_data = parse_roll_sets_from_message event.content
        dice_rolls =  dice_roll_data.map { |roll| handle_dice_roll roll }
        if dice_rolls.length == 1
          respond_with_embedded_single_role(
            event: event,
            description: description,
            roll_data: dice_rolls[0]
          )
        else
          respond_with_embedded_multi_role(
            event: event,
            description: description,
            roll_data: dice_rolls
          )
        end
      end
    end
  end
end

