def fizzbuzz(number)
  # 3でも5でも割り切れる場合
  if number % 15  == 0
    'FizzBuzz'
  # 3で割り切れる場合
  elsif number % 3 == 0
    'Fizz'
  # 5で割り切れる場合
  elsif number % 5 == 0
    'Buzz'
  else
    number
  end
end

(1..20).each do |number|
  puts fizzbuzz(number)
end