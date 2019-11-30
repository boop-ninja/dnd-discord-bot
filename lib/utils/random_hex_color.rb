# frozen_string_literal: true

require 'securerandom'

def random_hex_color
  +('0x' + SecureRandom.hex(3))
end
