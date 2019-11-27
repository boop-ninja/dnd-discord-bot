# frozen_string_literal: true

require 'discordrb'
require_relative 'lib/utils/environment'
require_relative 'lib/utils/command'
require_relative 'lib/commands/snuggle'
require_relative 'lib/commands/roll'
require_relative 'lib/utils/format_user_id'
require_relative 'lib/utils/parse_user_ids'

bot = Discordrb::Bot.new token: DISCORD_BOT_TOKEN

command(bot, /!roll/i) { |event| roll event }
command(bot, /!snuggle/i) { |event, user_ids| snuggle event, user_ids }

bot.run
