class Recipe

  def self.connect_database_and_execute_sql_statement(options, sql_statement)
    options[:test_output] ? which_database = "test" : which_database = "production"
    database = SQLite3::Database.new("db/recipe_tracker_#{which_database}.sqlite3")
    database.execute(sql_statement)
  end

  def self.create(name, options)
    sql_statement = "INSERT INTO recipes VALUES ('#{name}', '#{options[:ingredients]}', '#{options[:directions]}', #{options[:time]}, '#{options[:meal]}', #{options[:serves]}, #{options[:calories]})"
    connect_database_and_execute_sql_statement(options, sql_statement)
  end

  def self.edit(name, options)
    old_name = name
    new_name = options[:recipe_name]
    puts "In EDIT function, with old name #{old_name} and new name #{new_name}."
    puts self.hash_to_array_of_strings(options)
#     sql_statement = " "
#     UPDATE table_name
# SET column1=value1,column2=value2,...
# WHERE some_column=some_value;
  end

  def self.hash_to_array_of_strings(hash)
    array = hash.to_a
    array_of_strings = []
    for i in 0..(array.length-1)
      assignment_string = array[i][0].to_s + "='" + array[i][1].to_s + "'"
      array_of_strings.push(assignment_string)
    end
    array_of_strings
  end
end