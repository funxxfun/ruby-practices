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

frames = shots.each_slice(2).to_a
point = 0
frames.each_with_index do |frame, index|
  if index <= 8
    next_frame = frames[index + 1]
    next_next_frame = frames[index + 2]
    if frame[0] == 10 && next_frame[0] == 10
      point += frame.sum + next_frame[0] + next_next_frame[0]
    elsif frame[0] == 10
      point += frame.sum + next_frame[0] + next_frame[1]
    elsif frame.sum == 10
      point += frame.sum + next_frame[0]
    else
      point += frame.sum
    end

  else
    point += frame.sum
  end
end

puts point
