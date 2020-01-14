require 'dynamoid'
require_relative '../config/environment'

Dynamoid.configure do |config|
  config.region = 'us-west-2'
  config.namespace = nil
end

module R4RBot
  module Models
    # class doc
    class Document
      include Dynamoid::Document

      table name: R4RBot::Environment.aws_dynamodb_table,
            key: :id,
            read_capacity: 5,
            write_capacity: 5

      range :tags, :string
      field :type

    end
  end
end

# server_id = 12345678.to_s
# tags = 'server_id=12345678,user=boop'
# # model = R4RBot::Models::DocumentV2.create(id: server_id, tags: tags)
# item = R4RBot::Models::Document.find(server_id, range_key: tags)
#
# puts item.tags
