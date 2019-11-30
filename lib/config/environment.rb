# frozen_string_literal: true

require 'dotenv/load'
require 'logger'

module R4RBot
  class Environment
    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def discord_bot_token
      ENV.fetch('DISCORD_BOT_TOKEN')
    end
  end
end
