# frozen_string_literal: true

def valid_json?(json)
  JSON.parse(json)
rescue JSON::ParserError => _e
  false
end
