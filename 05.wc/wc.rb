#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.on('-l') { |v| options[:l] = v }
  opts.on('-w') { |v| options[:w] = v }
  opts.on('-c') { |v| options[:c] = v }
end.parse!

def print_wc(content, options, label = '')
  line_count = content.lines.size
  word_count = content.split(/\s+/).size
  char_count = content.bytesize

  output = ''
  output += line_count.to_s.rjust(8) if options[:l] || options.empty?
  output += word_count.to_s.rjust(8) if options[:w] || options.empty?
  output += char_count.to_s.rjust(8) if options[:c] || options.empty?
  puts "#{output} #{label}"

  [line_count, word_count, char_count]
end

def process_stdin(options)
  content = $stdin.read
  print_wc(content, options)
end

def process_files(file_names, options)
  total_lines = 0
  total_words = 0
  total_chars = 0

  if file_names.empty?
    process_stdin(options)
  else
    file_names.each do |file_name|
      if File.exist?(file_name)
        content = File.read(file_name)
        counts = print_wc(content, options, file_name)
        total_lines += counts[0]
        total_words += counts[1]
        total_chars += counts[2]
      else
        puts "wc: #{file_name}: open: No such file or directory"
      end
    end
    print_total(total_lines, total_words, total_chars, options) if file_names.size > 1
  end
end

def print_total(total_lines, total_words, total_chars, options)
  output_total = ''
  output_total += total_lines.to_s.rjust(8) if options[:l] || options.empty?
  output_total += total_words.to_s.rjust(8) if options[:w] || options.empty?
  output_total += total_chars.to_s.rjust(8) if options[:c] || options.empty?
  puts "#{output_total} total"
end

file_names = ARGV
process_files(file_names, options)
