# frozen_string_literal: true

require 'logger'
require 'minitest/autorun'
require_relative '../../lib/utils/srd'

module R4RBot
  module Tests
    class TestSRD < Minitest::Test
      attr_accessor :logger
      def setup
        @logger = Logger.new(STDOUT)
        @logger.level = Logger::ERROR

      end

      def srd(stub_name)
        @srd ||= R4RBot::Utils::SRD.new logger: logger, name: stub_name
      end

      def validate_field_value(stub_name, item_name, value)
        assert(value.is_a?(String))
        refute(value.include?('R4RBot::Utils::SRDEntry'))
        refute(
          value.match?(/^({.+}|\[.+\])$/),
          "Invalid value found!: #{value} with '#{item_name}' in '#{stub_name}'"
        )
      end

      srd_path = File.expand_path(File.join(__FILE__, %w[../../.. data WOTC_5e_SRD_v5.1]))
      entries = Dir.entries(srd_path).map do |file_name|
        File.basename(file_name, '.json')
      end
      entries.reject! do |e|
        %w[. ..].include? e
      end
      entries.each do |stub_name|
        define_method :"test_#{stub_name}" do
          loaded_srd = srd(stub_name)
          loaded_srd.names.each do |item_name|
            item = loaded_srd.find_by_name item_name
            assert(item, "Item not found #{stub_name}, #{item_name}")
            assert(item.to_discord_fields.length.positive?, "Received a zero length array for #{stub_name}, #{item_name}")
            item.to_discord_fields.each do |item|
              name = item[:name]
              value = item[:value]
              inline = item[:inline]
              validate_field_value stub_name, item_name, name
              validate_field_value stub_name, item_name, value
              assert(inline.is_a?(TrueClass) || inline.is_a?(FalseClass))
            end
          end
        end
      end
    end
  end
end



