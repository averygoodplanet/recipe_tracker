class Recipe

  def self.create(name, options)
    sql_statement = "INSERT INTO recipes(recipe_name, ingredients, directions, time, meal, serves, calories) VALUES('#{name}', '#{options[:ingredients]}', '#{options[:directions]}', #{options[:time]}, '#{options[:meal]}', #{options[:serves]}, #{options[:calories]})"
    which_database = options.include?(:test_output)
    execute_sql(sql_statement, which_database)
  end

  def self.view(name, which_database)
    unformatted_recipe = retrieve(name, which_database)
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
    which_database = options.include?(:test_output)
    # Need to remove test_output from options hash so that it isn't placed in
    # the sql_statement.
    options.delete(:test_output)
    serialization = self.serialize_hash(options)
    sql_statement = "UPDATE recipes SET #{serialization} WHERE recipe_name=#{old_name}"
    execute_sql(sql_statement, which_database)
  end

  def self.delete(name, options)
    # puts "in delete function****"
    which_database = options.include?(:test_output)
    puts which_database
    sql_statement = "DELETE from recipes WHERE recipe_name='#{name}'"
    puts sql_statement
    execute_sql(sql_statement, which_database)
  end

  def self.import(csv_filename_in_data_folder)
    file_path = File.realpath(File.join('data', csv_filename_in_data_folder))
    array_of_arrays = CSV.read(file_path)
    puts array_of_arrays
    puts array_of_arrays.inspect
  end

######### Helper Functions #################

  def self.execute_sql(sql_statement, which_database = false)
    which_database == true ? which_database = "test" : which_database = "production"
    database = SQLite3::Database.new("db/recipe_tracker_#{which_database}.sqlite3")
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

  def self.retrieve(name, which_database = false)
    which_database == true ? which_database = "test" : which_database = "production"
    database = SQLite3::Database.new("db/recipe_tracker_#{which_database}.sqlite3")
    sql_statement = "select recipe_name, ingredients, directions, time, meal, serves,calories from recipes WHERE recipe_name='#{name}'"
    recipe_array = database.execute(sql_statement)[0]
    recipe_array
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