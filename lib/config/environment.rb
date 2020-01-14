require 'dotenv/load'
require 'logger'
require 'staccato'
require 'aws-sdk-dynamodb'

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

    def self.google_analytics_site_id
      ENV.fetch('GOOGLE_ANALYTICS_SITE_ID')
    end

    def self.logger
      @logger ||= Logger.new(STDOUT)
    end

    def self.tracker
      @tracker ||= Staccato.tracker(google_analytics_site_id)
    end

  end
end
