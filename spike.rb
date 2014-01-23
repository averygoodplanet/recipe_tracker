#!/usr/bin/env ruby

# from looking at http://rubylearning.com/blog/2011/01/03/how-do-i-make-a-command-line-tool-in-ruby/

# switches on different first argument
case ARGV[0]
when "start"
  STDOUT.puts "called start"
when "stop"
  STDOUT.puts "called stop"
when "restart"
  STDOUT.puts "called restart"
else
  STDOUT.puts <<-EOF
Please provide command name

Usage:
  server start
  server stop
  server restart
EOF
end