#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

COLUMNS_COUNT = 3

def files(path = '.', options)
  opt = OptionParser.new
  opt.on('-r') { |v| options[:r] = v }
  opt.on('-l') { |v| options[:l] = v }
  opt.parse!(ARGV)

  files = Dir.entries(path).reject { |file| file.start_with?('.') }.sort
  files = files.reverse if options[:r]
  files
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

def display_long_format(entries)
  entries.each do |entry|
    file = File.stat(entry)
    file_type = file.ftype
    file_permissions = file.mode
    file_nlink = file.nlink
    file_owner = file.uid
    file_group = file.gid
    file_size = file.size
    time_stamp = file.mtime
    puts "#{file_type}#{file_permissions} #{file_nlink} #{file_owner} #{file_group} #{file_size} #{time_stamp} #{entry}"
  end
end

options = {}
entries = files('.', options)

if options[:l]
  display_long_format(entries)
else
  display_columns(entries)
end
