#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

COLUMNS_COUNT = 3

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
  file_types = {
    'file' => '-',
    'directory' => 'd',
    'characterSpecial' => 'c',
    'blockSpecial' => 'b',
    'fifo' => 'p',
    'link' => 'l',
    'socket' => 's'
  }
  file_types[file_type]
end

def format_permissions(file)
  file_permissions = file.mode.to_s(8).slice(-3, 3).chars.map(&:to_i)
  file_permissions = file_permissions.map do |permission|
    case permission
    when 0 then '---'
    when 1 then '--x'
    when 2 then '-w-'
    when 3 then '-wx'
    when 4 then 'r--'
    when 5 then 'r-x'
    when 6 then 'rw-'
    when 7 then 'rwx'
    end
  end
  file_permissions.join
end

def display_long_format(entries)
  entries.each do |entry|
    file = File.stat(entry)
    file_type = format_file_type(entry)
    file_permissions = format_permissions(file)
    file_nlink = file.nlink.to_s
    file_owner = Etc.getpwuid(file.uid).name
    file_group = Etc.getgrgid(file.gid).name
    file_size = file.size.to_s
    time_stamp = file.mtime.strftime('%-m %e %H:%M')
    puts "#{file_type}#{file_permissions} #{file_nlink.rjust(2)} #{file_owner.rjust(6)} #{file_group.rjust(6)} #{file_size.rjust(5)} #{time_stamp.rjust(11)} #{entry}"
  end
end

options = {}
entries = files(options, '.')

if options[:l]
  display_long_format(entries)
else
  display_columns(entries)
end
