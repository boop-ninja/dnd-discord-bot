# frozen_string_literal: true

require 'logger'
require_relative 'utils/parse_user_ids'
require_relative 'errors/invalid_message_args'

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
      def initialize(environment:, client:, event:, bot:, logger:)
        @environment = environment
        @client = client
        @event = event
        @bot = bot
        @logger = logger || @environment.logger
      end

      def fulfill(event)
        event.respond 'Im feel fulfilled! :D'
      end

      def send_help(event)
        event.respond 'You have been helped <3'
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
        help_regex = self.class.escape_string("!#{self.class.keyword} help")
        needs_help = help_regex.match?(event.content)
        needs_help ? send_help(event) : fulfill(event)
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

        def escape_string(str)
          Regexp.new(Regexp.escape(str), Regexp::IGNORECASE)
        end

        # Default registration is just a 'start_with'

        def registrations
          start_with = escape_string("!#{keyword}")
          {
            start_with: start_with
          }
        end

        # @param environment [Environment] The environment.
        # @param client [Discordrb::Bot] The Discord bot instance.
        # @param bot [R4RBot::DiscordClient] The bot client
        def register(environment:, client:, bot:)
          opts = {
            environment: environment,
            client: client,
            bot: bot,
            logger: environment.logger
          }
          registrations.each_pair do |key, value|
            client.message(key => value) do |event|
              new(**opts.merge(event: event)).handle_event(event)
            end
            client.message_edit(key => value) do |event|
              new(**opts.merge(event: event)).handle_event(event)
            end
          end
        end
      end
    end
  end
end