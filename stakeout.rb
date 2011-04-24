#!/usr/bin/env ruby
# by http://bparanj.blogspot.com/2010/07/extremely-simple-alternative-to.html
if ARGV.size < 2
  puts "Usage: stakeout.rb [command] [files to watch]+"
  exit 1
end

command = ARGV.shift
files = {}
ARGV.each do |arg|
  Dir[arg].each { |file| files[file] = File.mtime(file) }
end

loop do
  sleep 1

  changed_file, last_changed = files.find { |file, last_changed| File.mtime(file) > last_changed }
  if changed_file
    files[changed_file] = File.mtime(changed_file)
    puts "=> #{changed_file} changed, running #{command}"
    puts system(command)
    puts "=> done"
  end
end