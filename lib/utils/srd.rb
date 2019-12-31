# frozen_string_literal: true

# def create_field(name, value, sub_name = nil)
#   #  dd
# end
#
# def parse_object_to_fields(obj)
#   obj.keys.map do |key|
#
#   end
# end
#
# def parse_array_to_fields(arr)
#   arr.map { |obj| parse_object_to_fields obj }
# end
#
# def parse_json_to_fields(json)
#   return parse_array_to_fields(json) if json.is_a?(Array)
#   return [parse_object_to_fields(json)] if json.is_a?(Hash)
#   return parse_json_to_fields(JSON.parse(json) if json.is_a?(String)
# rescue JSONError => _e
#   puts 'Invalid Json'
# end

require 'json'
require_relative 'srd_entry'
require_relative '../errors/file_not_found'


module R4RBot
  module Utils
    class SRD
      attr_accessor :logger
      def initialize(logger:, name:)
        unless file_names.include? name.to_s
          raise(R4RBot::Errors::FileNotFound, "The stub #{name} was not found.")
        end

        @logger = logger
        load_file(name.to_s)
      end

      def file_names
        data_files.map { |p| File.basename(p, '.json') }
      end

      def data_files
        json_file_paths = File.expand_path(File.join(__FILE__ , '../../..', 'data', 'WOTC_5e_SRD_v5.1'))
        json_files = Dir.entries(json_file_paths)
        json_files.reject! { |p| %w[. ..].include? p }
        json_files.map { |e| File.expand_path(File.join(json_file_paths, e)) }
      end

      def load_file(file_name)
        data_file = data_files.find { |file| file.include?(file_name) }
        @content = JSON.parse(File.read(data_file), object_class: R4RBot::Utils::SRDEntry)
      end

      def all
        @content
      end

      def names
        @names ||= @content.map { |e| e[:name] }.select{ |e| e.is_a?(String) }
      end

      # @return [R4RBot::Utils::SRDEntry]
      def find_by_name(name)
        @content.find do |e|
          Regexp.new(Regexp.escape(name), Regexp::IGNORECASE).match?(e.name)
        end
      end

      private :file_names, :data_files, :load_file
    end
  end
end
