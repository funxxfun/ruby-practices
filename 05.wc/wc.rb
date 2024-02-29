#!/usr/bin/env ruby

require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.on("-l") { |v| options[:l] = v }
end.parse!

def print_wc(file_name, options)
  content = File.read(file_name)
  line_count = content.lines.size
  word_count = content.split(/\s+/).size
  char_count = content.bytesize

  if options[:l]
    puts "#{line_count.to_s.rjust(8)} #{file_name}"
  else
    puts "#{line_count.to_s.rjust(8)} #{word_count.to_s.rjust(8)} #{char_count.to_s.rjust(8)} #{file_name}"
  end

  [line_count, word_count, char_count]
end

def process_files(file_names, options)
  total_lines = 0
  total_words = 0
  total_chars = 0

  file_names.each do |file_name|
    if File.exist?(file_name)
      counts = print_wc(file_name, options)
      total_lines += counts[0]
      total_words += counts[1]
      total_chars += counts[2]
    else
      puts "wc: #{file_name}: open: No such file or directory"
    end
  end

  if file_names.size > 1
    if options[:l]
      puts "#{total_lines.to_s.rjust(8)} total"
    else
      puts "#{total_lines.to_s.rjust(8)} #{total_words.to_s.rjust(8)} #{total_chars.to_s.rjust(8)} total"
    end
  end
end

file_names = ARGV

if file_names.empty?
  puts "wc: open: No such file or directory"
else
  process_files(file_names, options)
end
