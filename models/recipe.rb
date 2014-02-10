class Recipe < ActiveRecord::Base

  def self.view(name)
    unformatted_recipe = retrieve(name)
    # remembering that [] is not nil
    if unformatted_recipe.nil? || unformatted_recipe.empty?
      puts "#{name} wasn't found in the database. Type --help for help menu."
      exit
    end
    formatted_recipe = format(unformatted_recipe)
    puts formatted_recipe
  end

  def self.edit(name, options)
    record = Recipe.find_by(recipe_name: name)
    record.update(options)
  end

  def self.delete(name, options)
    record = Recipe.find_by(recipe_name: name)
    record.destroy
  end

  def self.import(csv_filename_in_data_folder)
    file_path = File.realpath(File.join('data', csv_filename_in_data_folder))
    name = ""
    options = {}
    CSV.foreach(file_path, headers: true) do |row_hash|
      options = { :recipe_name => row_hash["recipe_name"],
                        :ingredients => row_hash["ingredients"],
                        :directions => row_hash["directions"],
                        :time => row_hash["time"],
                        :meal => row_hash["meal"],
                        :serves => row_hash["serves"],
                        :calories => row_hash["calories"]}
      Recipe.create(options)
    end
  end

  def self.all_recipe_names
    Recipe.pluck(:recipe_name).sort
  end

  def self.retrieve(name)
     Recipe.where(recipe_name: name).pluck(:recipe_name, :ingredients, :directions, :time, :meal, :serves, :calories).flatten
  end

  def self.recipes_under_calories(calories)
    Recipe.where("calories < ?", calories.to_i).pluck(:recipe_name)
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