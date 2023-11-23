#!/usr/bin/env ruby
# frozen_string_literal: true

require 'debug'

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
  if index <= 8 # 1~9フレーム
    point += if frame[0] == 10 && frames[index + 1][0] == 10 # 連続ストライクの時
               frame.sum + frames[index + 1][0] + frames[index + 2][0] + frames[index + 2][1]
             elsif frame[0] == 10 # 連続しないストライクの時
               frame.sum + frames[index + 1][0] + frames[index + 1][1]
             elsif frame.sum == 10 # スペアの時
               frame.sum + frames[index + 1][0]
             else
               frame.sum
             end
  end

  point += frame.sum if index >= 9 # 10フレーム
end
p frames
p point

puts
