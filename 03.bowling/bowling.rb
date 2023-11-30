#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = []
shots.each_slice(2) do |s|
  frames << s
end

point = 0
frames.each_with_index do |frame, index|
  if index <= 8
    point += if frame[0] == 10 && frames[index + 1][0] == 10
               frame.sum + frames[index + 1][0] + frames[index + 2][0]
             elsif frame[0] == 10
               frame.sum + frames[index + 1][0] + frames[index + 1][1]
             elsif frame.sum == 10
               frame.sum + frames[index + 1][0]
             else
               frame.sum
             end
  else
    point += frame.sum
  end
end

puts point
