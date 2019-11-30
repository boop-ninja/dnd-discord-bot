# frozen_string_literal: true

require 'logger'
require_relative 'parse_user_ids'

module R4RBot
  module Commands
    # Idea: instead of #invoke causing side effects on client and environment,
    # perhaps it should return an array of command objects to be enacted by the caller?
    class Command
      attr_reader :environment, :client, :event, :logger, :bot

      # @param environment [Environment] The environment.
      # @param client [Discordrb::Bot] The Discord bot instance.
      # @param event [Discordrb::Event] The event which caused this command invocation.
      # @param bot [R4RBot::DiscordClient] The bot client
      def initialize(environment:, client:, event:, bot:)
        @environment = environment
        @client = client
        @event = event
        @bot = bot
        @logger = @environment.logger
      end


      class << self
        def subclasses
          ObjectSpace.each_object(Class).select { |klass| klass < self }
        end

        # Default registration is just a 'start_with'

        def registrations
          start_with =
            Regexp.new(Regexp.escape("!#{keyword}"), Regexp::IGNORECASE)
          {
            start_with: start_with
          }
        end

        # @param environment [Environment] The environment.
        # @param client [Discordrb::Bot] The Discord bot instance.
        # @param bot [R4RBot::DiscordClient] The bot client
        def register(environment:, client:, bot:)
          registrations.each_pair do |key, value|
            client.message(key => value) do |event|
              user_ids = parse_user_ids(event.content)
              new(
                environment: environment,
                client: client,
                event: event,
                bot: bot
              )
                .fulfill(event, user_ids)
            end

            client.message_edit(key => value) do |event|
              user_ids = parse_user_ids(event.content)
              new(
                environment: environment,
                client: client,
                event: event,
                bot: bot
              )
                .fulfill(event, user_ids)
            end
          end
        end
      end
    end
  end
end