#!/usr/bin/env ruby

require 'date'
require 'optparse'

params = ARGV.getopts('y:', 'm:')
year = params['y'] ? params['y'].to_i : Date.today.year
month = params['m'] ? params['m'].to_i : Date.today.month

day = Date.new(year, month)

puts day.strftime("%m月 %Y").center(20)
puts "日 月 火 水 木 金 土"
first_day = Date.new(day.year, day.month, 1)
last_day = Date.new(day.year, day.month, -1)
print "   " * first_day.wday
(first_day..last_day).each do |date|
  # 横並びに表示したいためputsではなくprintで出力する
  if date.day <= 9
    print " " + "#{date.day}" + " "
  else
    print "#{date.day}" + " "
  end

  if date.saturday?
    print "\n"
  end
end
