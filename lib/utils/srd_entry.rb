module R4RBot
  module Utils
    class SRDEntry < OpenStruct

      private

      def normalize_name(name)
        name.to_s.gsub('_', ' ').capitalize
      end

      def normalize_value(value)
        if value.is_a?(Array) && value.all?(R4RBot::Utils::SRDEntry)
          value
        elsif value.is_a?(Array) && value.all?(String)
          value.join(', ').capitalize
        elsif value.is_a?(R4RBot::Utils::SRDEntry)
          value.to_h
        else
          value.to_s.capitalize
        end
      end

      def array_to_fields(base_name, value)
        value.map do |sub_obj|
          next unless sub_obj

          sub_obj = sub_obj.to_h if sub_obj.is_a?(R4RBot::Utils::SRDEntry)
          sub_obj.keys.map do |key|
            name = format(
              '%<base_name>s - %<sub_name>',
              base_name: base_name.capitalize,
              sub_name: key.capitalize
            )
            value = normalize_value sub_obj[key]
            next unless value || value.to_s.length.zero?

            {
              name: normalize_name(name),
              value: value.to_s,
              inline: value.length < 25
            }
          end
        end
      end

      public

      def to_discord_fields(ignored_keys = [])
        obj = to_h
        arr = obj.keys.map! do |key|
          name = key
          value = normalize_value obj[key]

          if value.is_a?(Array)
            array_to_fields(key, value)
          else
            next unless value || value.to_s.length.zero?

            {
              name: normalize_name(name),
              value: value.to_s,
              inline: value.length < 25
            }
          end
        end
        return arr unless arr.respond_to?(:flatten!)
        return arr unless arr.respond_to?(:filter)

        arr.flatten!
        arr.filter do |last_check|
          last_check[:name].length.positive? &&
            last_check[:value].length.positive? &&
            last_check != '{}' &&
            !ignored_keys.include?(last_check[:name].downcase)
        end
      end
    end
  end
end
