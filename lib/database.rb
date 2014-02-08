require "sqlite3"

class Database < SQLite3::Database
  def self.connection(environment)
    @connection ||= Database.new("db/recipe_tracker_#{environment}.sqlite3")
  end

  def execute(statement)
    Environment.logger.info("Executing: " + statement)
    super(statement)
  end
end