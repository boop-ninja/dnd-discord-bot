# frozen_string_literal: true

# @param bot [Discordrb::Bot]
# @param prefix [Regexp]
# @yield [event, user_ids]
# @yieldparam event [Discordrb::Events::MessageEventHandler]
# @yieldparam user_ids [Array]
def command(bot, prefix)
  bot.message(start_with: prefix) do |event|
    user_ids = parse_user_ids(event.content)
    yield event, user_ids
  end
end
