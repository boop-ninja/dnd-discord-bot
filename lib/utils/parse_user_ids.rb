# frozen_string_literal: true

def parse_user_ids(message_content)
  message_content.match(/(\<\@|\<\@\!)(\d*)\>/).to_a.select do |x|
    x.to_i.positive?
  end
end
