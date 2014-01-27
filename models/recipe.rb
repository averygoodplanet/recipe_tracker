class Recipe
  def self.create(name, options)
    options[:test_output] ? which_database = "test" : which_database = "production"
    database = SQLite3::Database.new("db/recipe_tracker_#{which_database}.sqlite3")
    sql_statement = "INSERT INTO recipes VALUES ('#{name}', '#{options[:ingredients]}', '#{options[:directions]}', #{options[:time]}, '#{options[:meal]}', #{options[:serves]}, #{options[:calories]})"
    database.execute(sql_statement)
  end

  def edit
    puts "In EDIT function"
  end
end