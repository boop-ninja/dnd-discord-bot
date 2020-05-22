require 'dotenv/load'
require 'logger'
require 'staccato'
require 'aws-sdk-dynamodb'
require 'redis'

module R4RBot
  class Environment

    def self.aws_region
      ENV.fetch('AWS_REGION', 'us-west-2')
    end

    def self.aws_dynamodb_table
      ENV.fetch('AWS_DYNAMODB_TABLE', 'dnd_discord_bot_development')
    end

    def self.dynamodb_client
      @dynamodb_client ||= Aws::DynamoDB::Client.new(region: 'us-west-2')
    end

    def self.discord_bot_token
      ENV.fetch('DISCORD_BOT_TOKEN')
    end

    def self.logger
      @logger ||= Logger.new(STDERR)
    end

    def redis
      @redis ||= Redis.new
    end

  end
end
