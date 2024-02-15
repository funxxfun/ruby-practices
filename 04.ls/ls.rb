#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

COLUMNS_COUNT = 3

FILE_TYPE =
  {
    'file' => '-',
    'directory' => 'd',
    'characterSpecial' => 'c',
    'blockSpecial' => 'b',
    'fifo' => 'p',
    'link' => 'l',
    'socket' => 's'
  }.freeze

FILE_PERMISSION =
  {
    0 => '---',
    1 => '--x',
    2 => '-w-',
    3 => '-wx',
    4 => 'r--',
    5 => 'r-x',
    6 => 'rw-',
    7 => 'rwx'
  }.freeze

def files(options, path = '.')
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

def format_file_type(file)
  file_type = File.stat(file).ftype
  FILE_TYPE[file_type]
end

def format_permissions(file)
  file_permissions = file.mode.to_s(8).slice(-3, 3).chars.map(&:to_i)
  file_permissions = file_permissions.map do |permission|
    FILE_PERMISSION[permission]
  end
  file_permissions.join
end

def display_long_format(entries)
  block_sizes = entries.map do |entry|
    file_stat = File.stat(entry)
    file_stat.blocks
  end
  total_blocks = block_sizes.sum
  puts "total #{total_blocks}"
  entries.each do |entry|
    file = File.stat(entry)
    file_type = format_file_type(entry)
    file_permissions = format_permissions(file)
    file_nlink = file.nlink.to_s
    file_owner = Etc.getpwuid(file.uid).name
    file_group = Etc.getgrgid(file.gid).name
    file_size = file.size.to_s
    time_stamp = file.mtime.strftime('%-m %e %H:%M')
    puts "#{file_type}#{file_permissions} " \
    "#{file_nlink.rjust(2)} #{file_owner.rjust(6)} #{file_group.rjust(6)} " \
    "#{file_size.rjust(5)} #{time_stamp.rjust(11)} #{entry}"
  end
end

options = {}
entries = files(options, '.')

if options[:l]
  display_long_format(entries)
else
  display_columns(entries)
end
