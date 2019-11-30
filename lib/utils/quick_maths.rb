# frozen_string_literal: true

# @return [Integer]
def quick_maths(operator, number_one, number_two)
  number_one = number_one.to_i
  number_two = number_two.to_i
  case operator + ''
  when '+'
    number_one + number_two
  when '-'
    number_one - number_two
  when '*'
    number_one * number_two
  else
    number_two = 1 if number_two.zero?
    number_one.div(number_two)
  end
end