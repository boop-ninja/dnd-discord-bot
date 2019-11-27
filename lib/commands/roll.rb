# frozen_string_literal: true

require_relative '../../lib/utils/normalize_content'

# @param [Discordrb::Events::MessageEventHandler] event
def roll(event)
  content = normalize_content event.content
  puts content
  event.channel.send_embed('') do |embed|
    embed.title = 'You made a roll!!'
    embed.description = 'Lets see them rolls bb!'
    embed.colour = 0xff00c8
    embed.add_field(name: 'Query:', value: format('%<author_id>s', opts))
    embed.add_field(name: 'Rolls:', value: format('%<recipient>s', opts))
    embed.add_field(name: 'Sum:', value: format('%<recipient>s', opts))
  end
end