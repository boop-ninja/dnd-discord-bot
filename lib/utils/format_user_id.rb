# frozen_string_literal: true

# @param [Object] user_number
def format_user_id(user_number)
  format('<@%<user_number>s>', user_number: user_number)
end
