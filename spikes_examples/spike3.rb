#!/usr/bin/env ruby

# from http://rubylearning.com/blog/2011/01/03/how-do-i-make-a-command-line-tool-in-ruby/

require 'optparse'

options = {}

opt_parser = OptionParser.new do |opt|
  opt.banner = "Usage: opt_parser COMMAND [OPTIONS]"
  opt.separator  ""
  opt.separator  "Commands"
  opt.separator  "     start: start server"
  opt.separator  "     stop: stop server"
  opt.separator  "     restart: restart server"
  opt.separator  ""
  opt.separator  "Options"

  # example where an option is followed by its own argument
  # the ALLCAPS is the option's argument
  opt.on("-e","--environment ENVIRONMENT","which environment you want server run") do |environment|
    options[:environment] = environment
  end

  # example where an option isn't followed by an argument
  opt.on("-d","--daemon","running on daemon mode?") do
    options[:daemon] = true
  end

  opt.on("-h","--help","help") do
    puts opt_parser
  end
end

# extracts options from ARGV, extracted value will be deleted from ARGV.
# this allows both of these command to work:
# ./spike3.rb start -e my_environment -d
# ./spike3.rb -e my_environment -d start
opt_parser.parse!

# this shows how you can route to different methods based on commands
# and options
case ARGV[0]
when "start"
  puts "call start on options #{options.inspect}"
when "stop"
  puts "call stop on options #{options.inspect}"
when "restart"
  puts "call restart on options #{options.inspect}"
else
  puts opt_parser
end