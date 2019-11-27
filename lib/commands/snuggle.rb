# frozen_string_literal: true

# @param [Discordrb::Events::MessageEventHandler] event
# @param [Array] user_ids
def snuggle(event, user_ids)
  user_id, *_other_ids = user_ids
  opts = {
    author_id: format_user_id(event.author.id),
    recipient: format_user_id(user_id)
  }
  if opts[:author_id] == opts[:recipient]
    event.respond format('I guess %<author_id>s is just in love with themselves..', opts)
  elsif !user_ids.empty?
    event.channel.send_embed('') do |embed|
      embed.title = 'Snuggle mode active!'
      embed.description = 'Snuggle bomb incoming!!!!'
      embed.colour = 0xff00c8
      embed.add_field(name: 'Snuggles From:', value: format('%<author_id>s', opts))
      embed.add_field(name: 'Snuggles To:', value: format('%<recipient>s', opts))
      embed.add_field(
        name: 'Kabooooom',
        value: format('%<author_id>s aggressively snuggles %<recipient>s', opts)
      )
    end
  else
    event.respond format('%<author_id>s you snuggled no one :(', opts)
  end
end
