# frozen_string_literal: true

require 'logger'
require_relative 'parse_user_ids'
require_relative '../errors/invalid_message_args'

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



      def respond_with_embedded_error(event, message)
        event.channel.send_embed('') do |embed|
          embed.title = 'Woah! Looks like we hit an issue!'
          embed.colour = 0xff0000
          name = format('%<value>s', value: 'Error:')
          value = format('%<value>s', value: message)
          embed.add_field name: name, value: value
        end
      end

      def handle_event(event)
        # /^!\w+\shelp$/i.match?(event.message.content)
        fulfill(event)
      rescue R4RBot::Errors::InvalidMessageArguments => e
        logger.error e.message
        respond_with_embedded_error event, e.message
      rescue StandardError => e
        logger.error format("%<message>s \n %<backtrace>s", message: e.message, backtrace: e.backtrace.join("\n"))
        respond_with_embedded_error event, e.message
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
              new(
                environment: environment,
                client: client,
                event: event,
                bot: bot
              ).handle_event event
            end

            client.message_edit(key => value) do |event|
              new(
                environment: environment,
                client: client,
                event: event,
                bot: bot
              ).handle_event event
            end
          end
        end
      end
    end
  end
end