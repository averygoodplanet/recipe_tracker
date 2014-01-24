class UserInterface
  attr_reader :options, :name, :command

  def initialize()
    @options = {}
    @command = ""
    @name = ""
  end

  def parse_options
      require 'optparse'
      options = {}

      opt_parser = OptionParser.new do |opt|
      opt.banner = "Usage: recipe_tracker COMMAND [OPTIONS]"
      opt.separator  ""
      opt.separator  "Commands"
      opt.separator  "     create: add a new recipe to database"
      opt.separator  ""
      opt.separator  "Options"

      # example where an option is followed by its own argument
      # the ALLCAPS is the option's argument
      opt.on("-i","--ingredients INGREDIENTS","ingredients in the recipe") do |ingredients|
        options[:ingredients] = ingredients
      end

      opt.on("-d","--directions DIRECTIONS","directions to prepare recipe") do |directions|
        options[:directions] = directions
      end

      opt.on("-t","--time TIME","estimated preparation time") do |time|
        options[:time] = time
      end

      opt.on("-m","--meal MEAL","type of recipe, e.g. entree") do |meal|
        options[:meal] = meal
      end

      opt.on("-s","--serves SERVES","number of people recipe serves") do |serves|
        options[:serves] = serves
      end

      opt.on("-c","--calories CALORIES","calories per serving") do |calories|
        options[:calories] = calories
      end

      opt.on("-o", "--test_output", "output for program testing") do |test_output|
        options[:test_output] = test_output
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
    @options = options
    @command = ARGV[0]
    @name = ARGV[1]
  end

  def check_for_missing_name
    if @name.nil?
      puts "Please enter a recipe name."
      exit
    end
  end
end