# frozen_string_literal: true

require 'discordrb'
require_relative 'lib/config/environment'
require_relative 'lib/utils/command'

require_relative 'lib/commands/ping'
require_relative 'lib/commands/roll'
require_relative 'lib/commands/snuggle'

environment = R4RBot::Environment.new
client = Discordrb::Bot.new token: environment.discord_bot_token


module R4RBot
  VERSION = '0.0.1'
end


R4RBot::Commands::Command.subclasses.each do |klass|
  klass.register environment: environment, client: client, bot: self
end

client.ready do |event|
  environment.logger.info 'Discord client ready!'
  client.game = "R4RBot #{R4RBot::VERSION}"
end

client.run
