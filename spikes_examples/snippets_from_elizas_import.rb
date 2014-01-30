#################################
##### from Eliza's importer.rb ##############

require 'csv'

class Importer
  def self.import(from_filename)
    CSV.foreach(from_filename, headers: true) do |row_hash|
      import_product(row_hash)
    end
  end

  def self.import_product(row_hash)
    category = Category.find_or_create(row_hash["category"])
    purchase = Purchase.create(
      name: row_hash["product"],
      calories: row_hash["calories"].to_i,
      price: row_hash["price"].to_f,
      category: category
    )
  end
end

###############################
#### from Eliza's category.rb #######


  def self.find_or_create name
    database = Environment.database_connection
    database.results_as_hash = true
    category = Category.new(name)
    results = database.execute("select * from categories where name = '#{category.name}'")

    if results.empty?
      database.execute("insert into categories(name) values('#{category.name}')")
      category.send("id=", database.last_insert_row_id)
    else
      row_hash = results[0]
      category.send("id=", row_hash["id"])
    end
    category
  end

#############################
###### from Eliza's purchase.rb ###

#example of controlling format of an instance variable through it's setter
# within it's class
  def price=(price)
    @price = price.to_f
  end

  def save
    database = Environment.database_connection
    category_id = category.nil? ? "NULL" : category.id
    if id
      database.execute("update purchases set name = '#{name}', calories = '#{calories}', price = '#{price}', category_id = #{category_id} where id = #{id}")
    else
      database.execute("insert into purchases(name, calories, price, category_id) values('#{name}', #{calories}, #{price}, #{category_id})")
      @id = database.last_insert_row_id
    end
    # ^ fails silently!!
    # ^ Also, susceptible to SQL injection!
  end

