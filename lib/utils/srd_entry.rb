require_relative '../utils/valid_hash'

module R4RBot
  module Utils
    class SRDEntry < OpenStruct

      def normalize_name(name)
        name.to_s.gsub('_', ' ').capitalize
      end

      def normalize_value(value)
        if value.is_a?(Array) && value.all?(R4RBot::Utils::SRDEntry)
          value.map(&:to_h)
        elsif value.is_a?(Array) && value.all?(String)
          value.join(', ').capitalize
        elsif value.is_a?(R4RBot::Utils::SRDEntry)
          value.to_h
        elsif value.is_a?(Array)
          value
        else
          value.to_s.capitalize
        end
      end

      def create_field(name, value)
        {
          name: normalize_name(name),
          value: value.to_s,
          inline: value.length < 25
        }
      end

      # @param [Object] obj
      # @param [String] parent_name
      # @return [Array]
      def object_to_fields(obj, parent_name = '')
        arr = obj.keys
        arr.map! do |key|
          next unless value || value.to_s.length.zero?

          value = normalize_value obj[key]
          if value.is_a?(Array)
            array_to_fields key, value
          elsif value.is_a?(Hash) || valid_hash?(value)
            hash_value = if value.is_a?(Hash)
                           value
                         else
                           JSON.parse(value.gsub('=>', ':'))
                         end
            object_to_fields(hash_value)
          else
            name_format_string = '%<name>s'
            if parent_name.length.positive?
              name_format_string = '%<parent_name>s - %<name>s' + name_format_string
            end
            name = format(
              name_format_string,
              name: key.capitalize,
              parent_name: parent_name.capitalize
            )
            create_field(name, value)
          end
        end
      end

      def array_to_fields(base_name, value)
        value.map do |sub_obj|
          next unless sub_obj

          sub_obj = sub_obj.to_h if sub_obj.is_a?(R4RBot::Utils::SRDEntry)
          object_to_fields sub_obj, base_name
        end
      end

      def to_discord_fields(ignored_keys = [])
        arr = [object_to_fields(to_h)].flatten
        arr.select do |last_check|
          last_check.is_a?(Hash) &&
            last_check[:name].length.positive? &&
            last_check[:value].length.positive? &&
            last_check != '{}' &&
            !ignored_keys.include?(last_check[:name].downcase)
        end
      end

      private :normalize_name, :normalize_value, :object_to_fields, :array_to_fields, :create_field

    end
  end
end
