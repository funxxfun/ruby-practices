#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

COLUMNS_COUNT = 3

def file_names(path = '.')
  opt = OptionParser.new
  params = {}
  opt.on('-r') { |v| params[:r] = v }
  opt.parse!(ARGV)

  file_names = Dir.entries(path).reject { |file_name| file_name.start_with?('.') }.sort
  file_names = file_names.reverse if params[:r]
  file_names
end

def display_columns(entries)
  max_length = entries.map(&:length).max
  max_length += 5
  format_entries = entries.map { |entry| entry.ljust(max_length) }

  format_entries << nil while format_entries.length % COLUMNS_COUNT != 0

  rows = format_entries.each_slice(format_entries.length / COLUMNS_COUNT).to_a
  rows.transpose.each do |row|
    puts row.join
  end
end

display_columns(file_names)
