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
    puts "In EDIT function, with old name #{name} and new name #{options[:recipe_name]}."
    puts options
#     sql_statement = "UPDATE recipes SET "
#     UPDATE table_name
# SET column1=value1,column2=value2,...
# WHERE some_column=some_value;
  end
end