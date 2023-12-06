#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  s == 'X' ? shots << 10 << 0 : shots << s.to_i
end

frames = shots.each_slice(2).to_a
point = 0
frames.each_with_index do |frame, index|
  point += frame.sum

  if index <= 8
    next_frame = frames[index + 1]
    next_after_next_frame = frames[index + 2]
    if frame[0] == 10 && next_frame[0] == 10
      point += next_frame[0] + next_after_next_frame[0]
    elsif frame[0] == 10
      point += next_frame[0] + next_frame[1]
    elsif frame.sum == 10
      point += next_frame[0]
    end
  end
end

puts point
