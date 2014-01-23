#!/usr/bin/env ruby

# from looking at http://rubylearning.com/blog/2011/01/03/how-do-i-make-a-command-line-tool-in-ruby/

# now he's dealing with the second argument, ARGV[1] as an "option"


# when an option shows up in 2nd argument, he adds it as a key in options hash
# e.g.  'filename start  -e', then options = {:e => nil}
# in ruby hash.keys returns array of keys only.
def parse_options
  options = {}
  case ARGV[1]
  when "-e"
    options[:e] = ARGV[2]
  when "-d"
    options[:d] = ARGV[2]
  end
  options
end

case ARGV[0]
when "start"
  # ".inspect" returns a string containing a human-readable representation of obj.
  STDOUT.puts "start on #{parse_options.inspect}"
when "stop"
  STDOUT.puts "stop on #{parse_options.inspect}"
when "restart"
  STDOUT.puts "restart on #{parse_options.inspect}"
else
  STDOUT.puts <<-EOF
Please provide command name

Usage:
  server start
  server stop
  server restart

  options:
    -e ENVIRONMENT. Default: development
    -d DEAMON, true or false. Default: true
EOF
end

puts "ARGV: #{ARGV.join(',')}"
puts "options: #{parse_options}"