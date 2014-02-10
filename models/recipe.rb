class Recipe

  def self.all
    # returns everything for all rows (except for id column)
    database = Environment.database_connection
    results = database.execute("select recipe_name, ingredients, directions, time, meal, serves,calories from recipes")
  end

  def self.create(name, options)
    sql_statement = "INSERT INTO recipes(recipe_name, ingredients, directions, time, meal, serves, calories) VALUES('#{name}', '#{options[:ingredients]}', '#{options[:directions]}', #{options[:time]}, '#{options[:meal]}', #{options[:serves]}, #{options[:calories]})"
    execute_sql(sql_statement)
  end

  def self.view(name)
    unformatted_recipe = retrieve(name)
    if unformatted_recipe.nil?
      puts "#{name} wasn't found in the database. Type --help for help menu."
      exit
    end
    formatted_recipe =format(unformatted_recipe)
    puts formatted_recipe
    # Exiting here to prevent extra test_output on -o
    exit
  end

  def self.edit(name, options)
    old_name = "'#{name}'"
    new_name = options[:recipe_name]
    serialization = self.serialize_hash(options)
    sql_statement = "UPDATE recipes SET #{serialization} WHERE recipe_name=#{old_name}"
    execute_sql(sql_statement)
  end

  def self.delete(name, options)
    sql_statement = "DELETE from recipes WHERE recipe_name='#{name}'"
    execute_sql(sql_statement)
  end

  def self.import(csv_filename_in_data_folder)
    file_path = File.realpath(File.join('data', csv_filename_in_data_folder))
    name = ""
    options = {}
    CSV.foreach(file_path, headers: true) do |row_hash|
      name = row_hash["recipe_name"]
      options = {:ingredients => row_hash["ingredients"],
                        :directions => row_hash["directions"],
                        :time => row_hash["time"],
                        :meal => row_hash["meal"],
                        :serves => row_hash["serves"],
                        :calories => row_hash["calories"]}
      create(name, options)
    end
  end

  def self.all_recipe_names
    sql_statement = "select recipe_name from recipes"
    recipe_array = execute_sql(sql_statement)
    recipe_array.flatten.sort
  end

######### Helper Functions #################

  def self.execute_sql(sql_statement)
    database = Environment.database_connection
=begin
this thread across files
(recipe.rb) database = Environment.database_connection
(environment.rb in self.database_connection) Database.connection(@@environment)
(database.rb in self.connection) @connection ||= Database.new("db/recipe_tracker_#{environment}.sqlite3")
=end
    database.execute(sql_statement)
  end

  def self.serialize_hash(hash)
    array = hash.to_a
    array_of_strings = []
    for i in 0..(array.length-1)
      assignment_string = array[i][0].to_s + "='" + array[i][1].to_s + "'"
      array_of_strings.push(assignment_string)
    end
    array_of_strings.join(",")
  end

  def self.find_by(recipe_name_hash)
    name = recipe_name_hash[:recipe_name]
    sql_statement = "select recipe_name, ingredients, directions, time, meal, serves,calories from recipes WHERE recipe_name='#{name}'"
    recipe_array = execute_sql(sql_statement)[0]
    recipe_array
  end

  def self.retrieve(name)
    sql_statement = "select recipe_name, ingredients, directions, time, meal, serves,calories from recipes WHERE recipe_name='#{name}'"
    recipe_array = execute_sql(sql_statement)[0]
    recipe_array
  end

  def self.recipes_under_calories(calories)
    sql_statement = "select recipe_name from recipes where calories < #{calories.to_i}"
    recipe_array = execute_sql(sql_statement)
    recipe_array.flatten
  end

  def self.format(unformatted_recipe)
    name, ingredients, directions, time, meal, serves, calories = unformatted_recipe[0], unformatted_recipe[1], unformatted_recipe[2], unformatted_recipe[3], unformatted_recipe[4], unformatted_recipe[5], unformatted_recipe[6]
    ingredients = ingredients.split(', ').join("\n")
    formatted_recipe = [ "*****",
                        "Recipe: #{name}", "\n",
                        "Ingredients:", "\n",
                        "#{ingredients}", "\n",
                        "Directions:", "\n",
                        "#{directions}", "\n",
                        "Time: #{time}",
                        "Meal: #{meal}",
                        "Serves: #{serves}",
                        "Calories: #{calories}",
                        "***end of recipe***", "\n"]
  end
end