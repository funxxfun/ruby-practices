#!/usr/bin/env ruby
# frozen_string_literal: true

COLUMNS_COUNT = 3

def file_directory(path = '.')
  Dir.entries(path).reject { |entry| entry.start_with?('.') }.sort
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

display_columns(file_directory)
