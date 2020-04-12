# frozen_string_literal: true
#
require 'json'
require 'logger'
require 'minitest/autorun'
require_relative '../../lib/commands/roll'
require_relative '../../lib/config/environment'
require_relative '../mock/event'
require_relative '../mock/logger'


module R4RBot
  module Tests
    class TestRollCommand < Minitest::Test
      attr_accessor :logger
      def call_roll_klass(event:)
        #noinspection RubyYardParamTypeMatch
        R4RBot::Commands::Roll.new(
          environment: R4RBot::Environment,
          client: MiniTest::Mock.new,
          event: event,
          bot: MiniTest::Mock.new,
          logger: R4RBot::Mocks::Logger
        )
      end

      mock_command_data = JSON.parse(File.read(File.join(File.dirname(__FILE__), './data/roll_mock_queries.json')))
      mock_command_data.each do |query|
        define_method :"test_mock_execute_#{query}" do
          content = "!roll #{query}"
          event =  R4RBot::Mocks::Event.new(content: content)
          channel_message = call_roll_klass(event: event).fulfill(event)

          if channel_message.length == 3
            roll_query = channel_message.find {|e| /query/i.match?(e[:name])}
            rolls = channel_message.find {|e| /rolls/i.match?(e[:name])}[:value].tr(' ', '').split(',')
            observed_sum = channel_message.find {|e| /sum/i.match?(e[:name])}
            predicted_sum = rolls.inject(0){|sum,x| sum.to_i + x.to_i }
            modifier = query[/([-+]\d{0,3})/,1]
            if modifier
              modifier_sym = modifier[0]
              modifier_num = modifier[1..]
              modifier_sym  == '+' ? predicted_sum += modifier_num.to_i : predicted_sum -= modifier_num.to_i
            end
            assert_equal(query, roll_query[:value])
            assert_equal(predicted_sum, observed_sum[:value].to_i)
          else
            roll_queries = channel_message.find {|e| /queries/i.match?(e[:name])}
            expected_queries = query.tr(' ', '').split(',')
            assert_equal(expected_queries, roll_queries[:value].tr(' ', '').split(','))
            expected_queries.each do |q|
              found_q = channel_message.find do |e|
                Regexp.new(Regexp.escape(e[:value]), Regexp::IGNORECASE).match?(q)
              end
              refute_nil(found_q)
            end
          end
        end
      end
    end
  end
end

