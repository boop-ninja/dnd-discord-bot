# frozen_string_literal: true

require 'json'
require_relative '../utils/command'
require_relative '../utils/normalize_content'
require_relative '../utils/quick_maths'
require_relative '../utils/random_hex_color'
require_relative '../utils/valid_json'
require_relative '../utils/srd'

module R4RBot
  module Commands
    class Lookup < Command
      def self.keyword
        'lookup'
      end

      def lookup_json_file_name(opt)
        found_key, *_found_values = {
          "armor": %w[armor a],
          "backgrounds": %w[background backgrounds b],
          "classes": %w[classes class c],
          "conditions": %w[conditions condition co],
          "documents": %w[documents document doc d],
          "feats": %w[feats feat f],
          "magic_items": %w[magicitems magic_items mi],
          "monsters": %w[monsters monster mon m],
          "planes": %w[planes plane p],
          "races": %w[races race r],
          "sections": %w[sections section sec se],
          "spells": %w[spells spell s],
          "weapons": %w[weapons weapon weap w]
        }.find do |_key, values|
          values.include?(opt.to_s.downcase)
        end
        found_key
      end

      def data_folder
        srd_folder = 'WOTC_5e_SRD_v5.1'
        file_dir = File.dirname(__FILE__)
        joined_path = File.join(file_dir, '../..', 'data', srd_folder)
        File.expand_path(joined_path)
      end

      def load_data(category = 'weapons')
        joined_path = File.join(data_folder, "./#{category.to_s}.json")
        json_path = File.expand_path(joined_path)
        JSON.parse(File.read(json_path))
      end

      # @param [Discordrb::Events::MessageEventHandler] event
      def fulfill(event)
        log_msg = format(
          'Received lookup request from %<username>s',
          username: event.user.nick || event.user.username
        )
        logger.info(log_msg)
        category, *item_name = normalize_content(event.content).split(' ')
        selected_category = lookup_json_file_name(category)

        if selected_category.to_s == 'classes'
          return event.respond "Sorry!! Unfortunately searching for `#{selected_category.to_s}` is not yet supported..."
        end

        data_file = R4RBot::Utils::SRD.new logger: logger, name: selected_category
        item = data_file.find_by_name(item_name.join(' ').downcase)

        unless item
          return event.respond "I didnt find anything while searching #{item_name.join(' ')} in #{selected_category}"
        end

        event.channel.send_embed('') do |embed|
          embed.title = item['name']
          embed.description = item['desc'] || item['name']
          embed.colour = random_hex_color
          item.to_discord_fields(%w[id name desc]).each do |field|
            next unless field

            embed.add_field(
              name: field[:name],
              value: field[:value],
              inline: field[:inline]
            )
          end
        end
      end
    end
  end
end

