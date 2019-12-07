# frozen_string_literal: true

run proc do |env|
  ['200', { 'Content-Type' => 'text/html' }, ['Bot is Online!']]
end
