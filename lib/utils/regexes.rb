module R4RBot
  module Utils
    module Regexes
      module Roll
        DICE_FILTER = /(\d{1,3})[dD](\d{1,3})([\s]?(\+|-)(\d{1,5}))?/
        DESCRIPTION_MESSAGE = /^\![[:alnum:]]*\s[[:alnum:]]*\s(.*)$/
      end
    end
  end
end