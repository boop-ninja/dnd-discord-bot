# frozen_string_literal: true

require 'discordrb'
require 'optparse'
require_relative 'lib/config/environment'
require_relative 'lib/utils/command'

require_relative 'lib/commands/ping'
require_relative 'lib/commands/roll'
require_relative 'lib/commands/snuggle'
require_relative 'lib/commands/lookup'

options = {
  daemonize: false
}

OptionParser.new do |opts|
  opts.banner = 'Usage: app.rb [options]'

  opts.on('-d', '--daemon', 'Run as daemon') do |v|
    options[:daemonize] = v
  end
end.parse!


environment = R4RBot::Environment.new
client = Discordrb::Bot.new token: environment.discord_bot_token

module R4RBot
  VERSION = ENV.fetch('HEROKU_RELEASE_VERSION', '1.0.0')
end


R4RBot::Commands::Command.subclasses.each do |klass|
  klass.register environment: environment, client: client, bot: self
end

client.ready do |event|
  environment.logger.info 'Discord client ready!'
  client.game = "R4RBot #{R4RBot::VERSION}"
end

client.run


