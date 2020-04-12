# frozen_string_literal: true

require 'discordrb'
require 'optparse'
require_relative 'version'
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

environment = R4RBot::Environment
client = Discordrb::Bot.new token: environment.discord_bot_token
client_id = client.bot_application.id
invite_url = "https://discordapp.com/oauth2/authorize?client_id=#{client_id}&scope=bot&permissions=68608"


R4RBot::Commands::Command.subclasses.each do |klass|
  klass.register environment: environment, client: client, bot: self
end

client.server_create do |event|
  environment.logger.info "Hey it looks like I just joined a new server! I am now part of #{event.server.name}."
  environment.tracker.event action: 'server_create', region: event.server.region_id
  environment.logger.info "We are now in #{client.servers.count} servers!"
end

client.ready do |event|
  environment.logger.info 'Discord client ready!'
  environment.logger.info "I am now part of #{client.servers.count} servers!"
  environment.logger.info "Here is my invite URL: #{invite_url}"
  client.game = "R4RBot #{R4RBot::VERSION}"
end

client.run


