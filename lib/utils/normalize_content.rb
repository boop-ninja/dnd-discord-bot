# frozen_string_literal: true

def normalize_content(content)
  content.sub(/^!\w+\W/, '')
end
