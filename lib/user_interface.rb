class UserInterface
  attr_reader :options, :name, :command

  def initialize()
    @options = {}
    @command = ""
    @name = ""
  end

  def start_program
    self.parse_options
    self.set_database_environment
    self.execute_command_line_command
  end

  def parse_options
      require 'optparse'
      options = {}

      opt_parser = OptionParser.new do |opt|
      opt.banner = "Usage: recipe_tracker COMMAND ['recipe name'] [OPTIONS]"
      opt.separator  ""
      opt.separator  "Commands"
      opt.separator  "     create: add a new recipe to database"
      opt.separator  "     view: display a recipe"
      opt.separator  "     edit: modify an existing recipe"
      opt.separator  "     delete: delete a recipe"
      opt.separator  "     import: import a CSV file from data folder"
      opt.separator "     calories_under: returns recipe names under number of calories"
      opt.separator "     all:  lists all recipe names in alphabetical order"
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

      opt.on("-n", "--recipe_name RECIPE_NAME", "indicated recipe name in edit phase") do |recipe_name|
        options[:recipe_name] = recipe_name
      end

      opt.on("-h","--help","help") do
        puts opt_parser
      end
    end
    # extracts options from ARGV, extracted value will be deleted from ARGV.
    opt_parser.parse!
    @options = options
    @command = ARGV[0]
    @name = ARGV[1]
  end

  def set_database_environment
    @options[:test_output] ? Environment.environment = "test" : Environment.environment = "production"
    @options.delete(:test_output)
    Environment.connect_to_database
  end

  def check_for_missing_name
    if @name.nil?
      puts "Please enter a recipe name."
      exit
    end
  end

  def check_for_missing_options(required_options)
    missing_options = required_options - @options.keys
    output_missing_options(missing_options) unless missing_options.empty?
  end

  def formatting_serves_output(missing_options)
    if missing_options.include?(:serves)
      index = missing_options.index(:serves)
      missing_options[index] = "number served"
    end
    missing_options
  end

  def output_missing_options(missing_options)
    missing_options = formatting_serves_output(missing_options)
    puts "You must provide the #{missing_options.join(" and ")} of the recipe you are creating."
    exit
  end

  def execute_command_line_command
    case @command
    when "create"
      self.check_for_missing_name
      required_options = [:ingredients, :directions, :time, :meal, :serves, :calories]
      self.check_for_missing_options(required_options)
      name_and_options = @options
      name_and_options[:recipe_name] = @name
      Recipe.create(name_and_options)
    when "view"
      self.check_for_missing_name
      Recipe.view(@name)
    when "edit"
      self.check_for_missing_name
      Recipe.edit(@name, @options)
    when "delete"
      self.check_for_missing_name
      Recipe.delete(@name, @options)
    when "import"
      self.check_for_missing_name
      Recipe.import(@name)
    when "calories_under"
      puts Recipe.recipes_under_calories(@name)
      exit
    when "all"
      # Re: pagination in cli using hirb: https://www.ruby-forum.com/topic/192016
      require 'hirb'
      Hirb::View.enable
      Hirb::View.capture_and_render { puts Recipe.all_recipe_names }
    end
  end
end # end of class