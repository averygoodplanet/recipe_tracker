###########1st commit from Wednesday 2/5 ############
###  "Add active_record and refactor requiring the model classes"

#Gemfile#############
 +gem 'activerecord'

#lib/environment.rb########
+require 'rubygems'
 +require 'bundler/setup'
 +require 'active_record'
 +project_root = File.dirname(File.absolute_path(__FILE__))
 +Dir.glob(project_root + "/../models/*.rb").each{|f| require f}
 -require_relative '../models/purchase'
 -require_relative '../models/category'

#test/test_categories.rb##########
 -require_relative '../models/category'

 #test/test_purchase.rb#########
-require_relative '../models/purchase'

####################################################

######### 2nd commit from Wednesday 2/5 ###############
## Refactoring database bootstrapping to ActiveRecord-based tasks

#Rakefile###########
+require 'active_record'
 -Rake::TestTask.new() do |t|
 +Rake::TestTask.new(test: "db:test:prepare") do |t|
 -desc 'create the production database setup'
 -task :bootstrap_database do
 -  Environment.environment = "production"
 -  database = Environment.database_connection
 -  create_tables(database)
 -end
 -desc 'prepare the test database'
 -task :test_prepare do
 -  File.delete("db/grocerytracker_test.sqlite3")
 -  Environment.environment = "test"
 -  database = Environment.database_connection
 -  create_tables(database)
 -end
 -def create_tables(database_connection)
 -  database_connection.execute("CREATE TABLE purchases (id INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(50), calories integer, price decimal(5,2), category_id integer)")
 -  database_connection.execute("CREATE TABLE categories (id INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(50))")
 +db_namespace = namespace :db do
 +  desc "Migrate the db"
 +  task :migrate do
 +    Environment.environment = 'production'
 +    Environment.connect_to_database
 +    ActiveRecord::Migrator.migrate("db/migrate/")
 +    db_namespace["schema:dump"].invoke
 +  end
 +  namespace :test do
 +    desc "Prepare the test database"
 +    task :prepare do
 +      Environment.environment = 'test'
 +      Environment.connect_to_database
 +      file = ENV['SCHEMA'] || "db/schema.rb"
 +      if File.exists?(file)
 +        load(file)
 +      else
 +        abort %{#{file} doesn't exist yet. Run `rake db:migrate` to create it.}
 +      end
 +    end
 +  end
 +  desc 'Rolls the schema back to the previous version (specify steps w/ STEP=n).'
 +  task :rollback do
 +    Environment.environment = 'production'
 +    Environment.connect_to_database
 +    step = ENV['STEP'] ? ENV['STEP'].to_i : 1
 +    ActiveRecord::Migrator.rollback(ActiveRecord::Migrator.migrations_paths, step)
 +    db_namespace["schema:dump"].invoke
 +  end
 +  namespace :schema do
 +    desc 'Create a db/schema.rb file that can be portably used against any DB supported by AR'
 +    task :dump do
 +      require 'active_record/schema_dumper'
 +      Environment.environment = 'production'
 +      Environment.connect_to_database
 +      filename = ENV['SCHEMA'] || "db/schema.rb"
 +      File.open(filename, "w:utf-8") do |file|
 +        ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
 +      end
 +    end
 +  end
  end

########### Her first commit from Thursday#################
### Refactor test database access into [MODEL].count

#####models/category.rb
 +  def self.count
 +    database = Environment.database_connection
 +    database.execute("select count(id) from categories")[0][0]
 +  end
 +

####models/purchase.rb
 +  def self.count
 +    database = Environment.database_connection
 +    database.execute("select count(id) from purchases")[0][0]
 +  end

####test/test_categories.rb
 class TestCategories < GroceryTest
 +  def test_count_when_no_categories
 +    assert_equal 0, Category.count
 +  end
 +
 +  def test_count_of_multiple_categories
 +    Category.find_or_create("foo")
 +    Category.find_or_create("Corn")
 +    Category.find_or_create("Cornflakes")
 +    assert_equal 3, Category.count
 +  end
 +
    def test_categories_are_created_if_needed
 -    foos_before = database.execute("select count(id) from categories")[0][0]
 +    foos_before = Category.count
      Category.find_or_create("Foo")
 -    foos_after = database.execute("select count(id) from categories")[0][0]
 +    foos_after = Category.count
      assert_equal foos_before + 1, foos_after
    end

    def test_categories_are_not_created_if_they_already_exist
      Category.find_or_create("Foo")
 -    foos_before = database.execute("select count(id) from categories")[0][0]
 +    foos_before = Category.count
      Category.find_or_create("Foo")
 -    foos_after = database.execute("select count(id) from categories")[0][0]
 +    foos_after = Category.count
      assert_equal foos_before, foos_after
    end

######test/test_entering_purchases.rb
 -    result = database.execute("select count(id) from purchases")
 -    assert_equal 1, result[0][0]
 +    assert_equal 1, Purchase.count

- result = database.execute("select count(id) from purchases")
 -    assert_equal 0, result[0][0]
 +    assert_equal 0, Purchase.count


 #####test/test_purchase.rb

  class TestPurchase < GroceryTest
 +  def test_count_when_no_purchases
 +    assert_equal 0, Purchase.count
 +  end
 +
 +  def test_count_of_multiple_purchases
 +    Purchase.create(name: "foo", calories: 130, price: 1.50)
 +    Purchase.create(name: "Corn", calories: 530, price: 1.00)
 +    Purchase.create(name: "Cornflakes", calories: 530, price: 1.00)
 +    assert_equal 3, Purchase.count
 +  end

 -    foos_before = database.execute("select count(id) from purchases")[0][0]
 +    foos_before = Purchase.count
      purchase.update(name: "Bar")
 -    foos_after = database.execute("select count(id) from purchases")[0][0]
 +    foos_after = Purchase.count

   -    foos_before = database.execute("select count(id) from purchases")[0][0]
 +    foos_before = Purchase.count
      purchase.save
 -    foos_after = database.execute("select count(id) from purchases")[0][0]
 +    foos_after = Purchase.count
      assert_equal foos_before + 1, foos_after

############Her 2nd commit from Thursday##########################
#####Remove the last SQL statements from the tests; also fix but with loading
#####categories

#####models/purchase.rb
     database.results_as_hash = true
      results = database.execute("select * from purchases where id = #{id}")[0]
      if results
 -      purchase = Purchase.new(name: results["name"], price: results["price"], calories: results["calories"])
 +      # This is not ideal.  We should be using a find method:
 +      category = Category.all.find{ |category| category.id == results["category_id"] }
 +      purchase = Purchase.new(name: results["name"], price: results["price"], calories: results["calories"], category: category)
        purchase.send("id=", results["id"])
        purchase
      else

#######test/test_entering_purchases
 def test_valid_purchase_gets_saved
      execute_popen("./grocerytracker add Cheerios --calories 210 --price 1.50 --environment test")
 -    database.results_as_hash = false
 -    results = database.execute("select name, calories, price from purchases")
 -    expected = ["Cheerios", 210, 1.50]
 -    assert_equal expected, results[0]
 +    purchase = Purchase.all.first
 +    expected = ["Cheerios", 210, "1.50"]
 +    actual = [purchase.name, purchase.calories, purchase.price]
 +    assert_equal expected, actual
      assert_equal 1, Purchase.count
    end

#######test/test_purchase.rb
 -    category_id = database.execute("select category_id from purchases where id='#{purchase.id}'")[0][0]
 +    category_id = Purchase.find(purchase.id).category.id
   -    category_id = database.execute("select category_id from purchases where id='#{purchase.id}'")[0][0]
 +    category_id = Purchase.find(purchase.id).category.id
   -    purchase = Purchase.create(name: "Foo", price: "1.50", calories: "10")
 +    category = Category.find_or_create("Things")
 +    purchase = Purchase.create(name: "Foo", price: "1.50", calories: "10", category: category)
      found = Purchase.find(purchase.id)
  +    assert_equal purchase.calories, found.calories
 +    assert_equal purchase.price, found.price
 +  def test_find_returns_the_purchase_with_correct_category
 +    category = Category.find_or_create("Things")
 +    purchase = Purchase.create(name: "Foo", price: "1.50", calories: "10", category: category)
 +    found = Purchase.find(purchase.id)
 +    refute_equal Category.default.id, found.category.id
 +    assert_equal category.id, found.category.id

################Her 3rd commit from Thursday########################
########Refactor model classes into ActiveRecord models#################

######grocerytracker
 def initialize
      @options = ArgumentParser.parse
      Environment.environment = @options[:environment] || "production"
 +    @options.delete(:environment)
    end

    def main
 -    database = Environment.database_connection
 +    Environment.connect_to_database

 -    if options[:command] == "search"
 +    command = options.delete(:command)
 +    if command == "search"
        search_term = ask("What do you want to search for?")
        search_purchases_for(search_term)
 -    elsif options[:command] == "add"
 +    elsif command == "add"
        add_purchase()
 -    elsif options[:command] == "list"
 +    elsif command == "list"
        list_purchases()
 -    elsif options[:command] == "edit"
 -      if purchase = Purchase.find(options[:id])
 +    elsif command == "edit"
 +      if purchase = Purchase.find_by(id: options[:id])
          purchase.update(options)
 -        puts "Purchase #{purchase.id} is now named #{purchase.name}, with #{purchase.calories} calories and $#{purchase.price} cost."
 +        puts "Purchase #{purchase.id} is now named #{purchase.name}, with #{purchase.calories} calories and #{purchase.formatted_price} cost."
        else
          puts "Purchase #{options[:id]} couldn't be found."
        end
 @@ -52,7 +54,7 @@ class GroceryTracker
      if error_messages.empty?
        purchase = Purchase.new(options)
        purchase.save
 -      puts "A purchase named #{purchase.name} (#{purchase.category.name}), with #{purchase.calories} calories and $#{purchase.price} cost was created."
 +      puts "A purchase named #{purchase.name} (#{purchase.category.name}), with #{purchase.calories} calories and #{purchase.formatted_price} cost was created."
      else
        puts error_messages.join(" ")
      end

#####lib/environment.rb
-  def self.database_connection
 -    Database.connection(@@environment)
 -  end

#####lib/importer.rb
   def self.import_product(row_hash)
 -    category = Category.find_or_create(row_hash["category"])
 +    category = Category.find_or_create_by(name: row_hash["category"].strip)
      purchase = Purchase.create(
 -      name: row_hash["product"],
 +      name: row_hash["product"].strip,

#####models/category.rb
-class Category
 -  attr_accessor :name
 -  attr_reader :id
 +class Category < ActiveRecord::Base
 +  default_scope { order("name ASC") }

    def self.default
 -    @@default ||= Category.find_or_create("Unknown")
 -  end
 -
 -  def initialize(name)
 -    self.name = name
 -  end
 -
 -  def name=(name)
 -    @name = name.strip
 -  end
 -
 -  def self.count
 -    database = Environment.database_connection
 -    database.execute("select count(id) from categories")[0][0]
 -  end
 -
 -  def self.all
 -    database = Environment.database_connection
 -    database.results_as_hash = true
 -    results = database.execute("select * from categories order by name ASC")
 -    results.map do |row_hash|
 -      category = Category.new(row_hash["name"])
 -      category.send("id=", row_hash["id"])
 -      category
 -    end
 -  end
 -
 -  def self.find_or_create name
 -    database = Environment.database_connection
 -    database.results_as_hash = true
 -    category = Category.new(name)
 -    results = database.execute("select * from categories where name = '#{category.name}'")
 -
 -    if results.empty?
 -      database.execute("insert into categories(name) values('#{category.name}')")
 -      category.send("id=", database.last_insert_row_id)
 -    else
 -      row_hash = results[0]
 -      category.send("id=", row_hash["id"])
 -    end
 -    category
 -  end
 -
 -  protected
 -
 -  def id=(id)
 -    @id = id
 +    Category.find_or_create_by(name: "Unknown")


####models/purchase.rb
-class Purchase
 -  attr_accessor :name, :price, :calories, :category
 -  attr_reader :id
 +class Purchase < ActiveRecord::Base
 +  belongs_to :category

 -  def initialize attributes = {}
 -    update_attributes(attributes)
 -    self.category ||= Category.default
 -  end
 -
 -  def price=(price)
 -    @price = price.to_f
 -  end
 -
 -  def calories=(calories)
 -    @calories = calories.to_i
 -  end
 +  default_scope { order("name ASC") }

 -  def self.count
 -    database = Environment.database_connection
 -    database.execute("select count(id) from purchases")[0][0]
 -  end
 -
 -  def self.create(attributes = {})
 -    purchase = Purchase.new(attributes)
 -    purchase.save
 -    purchase
 -  end
 +  before_create :set_default_category

 -  def update attributes = {}
 -    update_attributes(attributes)
 -    save
 -  end
 -
 -  def save
 -    database = Environment.database_connection
 -    category_id = category.nil? ? "NULL" : category.id
 -    if id
 -      database.execute("update purchases set name = '#{name}', calories = '#{calories}', price = '#{price}', category_id = #{category_id} where id = #{id}")
 -    else
 -      database.execute("insert into purchases(name, calories, price, category_id) values('#{name}', #{calories}, #{price}, #{category_id})")
 -      @id = database.last_insert_row_id
 -    end
 -    # ^ fails silently!!
 -    # ^ Also, susceptible to SQL injection!
 -  end
 +  # def price=(price)
 +  #   @price = price.to_f
 +  # end

 -  def self.find id
 -    database = Environment.database_connection
 -    database.results_as_hash = true
 -    results = database.execute("select * from purchases where id = #{id}")[0]
 -    if results
 -      # This is not ideal.  We should be using a find method:
 -      category = Category.all.find{ |category| category.id == results["category_id"] }
 -      purchase = Purchase.new(name: results["name"], price: results["price"], calories: results["calories"], category: category)
 -      purchase.send("id=", results["id"])
 -      purchase
 -    else
 -      nil
 -    end
 -  end
 +  # def calories=(calories)
 +  #   @calories = calories.to_i
 +  # end

    def self.search(search_term = nil)
 -    database = Environment.database_connection
 -    database.results_as_hash = true
 -    results = database.execute("select purchases.* from purchases where name LIKE '%#{search_term}%' order by name ASC")
 -    results.map do |row_hash|
 -      purchase = Purchase.new(
 -                  name: row_hash["name"],
 -                  price: row_hash["price"],
 -                  calories: row_hash["calories"])
 -      # Ideally: purchase.category = Category.find(row_hash["category_id"])
 -      # Not Ideally :(
 -      category = Category.all.find{|category| category.id == row_hash["category_id"]}
 -      purchase.category = category
 -      purchase.send("id=", row_hash["id"])
 -      purchase
 -    end
 -  end
 -
 -  # class << self
 -  #   alias :all :search
 -  # end
 -  # ^ is an alternative to:
 -  def self.all
 -    search
 +    Purchase.where("name LIKE ?", "%#{search_term}%").to_a
    end

 -  def price
 -    sprintf('%.2f', @price) if @price
 +  def formatted_price
 +    "$%04.2f" % price
    end

    def to_s
 -    "#{name}: #{calories} calories, $#{price}, id: #{id}"
 +    "#{name}: #{calories} calories, #{formatted_price}, id: #{id}"
    end

 -  def ==(other)
 -    other.is_a?(Purchase) && self.to_s == other.to_s
 -  end
 -
 -  protected
 +  private

 -  def id=(id)
 -    @id = id
 -  end
 -
 -  def update_attributes(attributes)
 -    # @price = attributes[:price]
 -    # @calories = attributes[:calories]
 -    # @name = attributes[:name]
 -    # ^ Long way
 -    # Short way:
 -    [:name, :price, :calories, :category].each do |attr|
 -      if attributes[attr]
 -        # self.calories = attributes[:calorie]
 -        self.send("#{attr}=", attributes[attr])
 -      end
 -    end
 +  def set_default_category
 +    self.category ||= Category.default
    end
  end

####test/helper.rb
-  def database
 -    Environment.database_connection
 +    Environment.connect_to_database
    end

    def teardown
 -    database.execute("delete from purchases")
 -    database.execute("delete from categories")
 +    # The Database Cleaner gem will do this for us:
 +    Category.destroy_all
 +    Purchase.destroy_all
    end

####test/test_categories.rb
+  def test_default_creates_correctly_named_file
 +    category = Category.default
 +    assert_equal "Unknown", category.name
 +    refute category.new_record?
 +  end
 +
 +  def test_default_creates_default_category
 +    assert_equal 0, Category.count
 +    Category.default
 +    assert_equal 1, Category.count
 +  end
 +
 +  def test_default_doesnt_create_duplicate_default
 +    category = Category.find_or_create_by(name: "Unknown")
 +    assert_equal category.id, Category.default.id
 +    assert_equal 1, Category.count
 +  end
 +
    def test_count_when_no_categories
      assert_equal 0, Category.count
    end

    def test_count_of_multiple_categories
 -    Category.find_or_create("foo")
 -    Category.find_or_create("Corn")
 -    Category.find_or_create("Cornflakes")
 +    Category.find_or_create_by(name: "foo")
 +    Category.find_or_create_by(name: "Corn")
 +    Category.find_or_create_by(name: "Cornflakes")
      assert_equal 3, Category.count
    end

    def test_categories_are_created_if_needed
      foos_before = Category.count
 -    Category.find_or_create("Foo")
 +    Category.find_or_create_by(name: "Foo")
      foos_after = Category.count
      assert_equal foos_before + 1, foos_after
    end

    def test_categories_are_not_created_if_they_already_exist
 -    Category.find_or_create("Foo")
 +    Category.find_or_create_by(name: "Foo")
      foos_before = Category.count
 -    Category.find_or_create("Foo")
 +    Category.find_or_create_by(name: "Foo")
      foos_after = Category.count
      assert_equal foos_before, foos_after
    end

 -  def test_existing_category_is_returned_by_find_or_create
 -    category1 = Category.find_or_create("Foo")
 -    category2 = Category.find_or_create("Foo")
 +  def test_existing_category_is_returned_by_find_or_create_by_name
 +    category1 = Category.find_or_create_by(name: "Foo")
 +    category2 = Category.find_or_create_by(name: "Foo")
      assert_equal category1.id, category2.id, "Category ids should be identical"
    end

    def test_create_creates_an_id
 -    category = Category.find_or_create("Foo")
 +    category = Category.find_or_create_by(name: "Foo")
      refute_nil category.id, "Category id shouldn't be nil"
    end

    def test_all_returns_all_categories_in_alphabetical_order
 -    Category.find_or_create("foo")
 -    Category.find_or_create("bar")
 +    Category.find_or_create_by(name: "foo")
 +    Category.find_or_create_by(name: "bar")
      expected = ["bar", "foo"]
      actual = Category.all.map{ |category| category.name }
      assert_equal expected, actual
16  test/test_entering_purchases.rb View
 @@ -2,9 +2,9 @@

  class TestEnteringPurchases < GroceryTest
    def test_user_is_presented_with_category_list
 -    cat1 = Category.find_or_create("Foo")
 -    cat2 = Category.find_or_create("Bar")
 -    cat3 = Category.find_or_create("Cereal")
 +    cat1 = Category.find_or_create_by(name: "Foo")
 +    cat2 = Category.find_or_create_by(name: "Bar")
 +    cat3 = Category.find_or_create_by(name: "Cereal")
      shell_output = ""
      IO.popen('./grocerytracker add Cheerios --calories 210 --price 1.50 --environment test', 'r+') do |pipe|
        pipe.puts "2"
 @@ -18,9 +18,9 @@ def test_user_is_presented_with_category_list
    end

    def test_user_chooses_category
 -    cat1 = Category.find_or_create("Foo")
 -    cat2 = Category.find_or_create("Bar")
 -    cat3 = Category.find_or_create("Cereal")
 +    cat1 = Category.find_or_create_by(name: "Foo")
 +    cat2 = Category.find_or_create_by(name: "Bar")
 +    cat3 = Category.find_or_create_by(name: "Cereal")
      shell_output = ""
      IO.popen('./grocerytracker add Cheerios --calories 210 --price 1.50 --environment test', 'r+') do |pipe|
        pipe.puts "2"
 @@ -31,7 +31,7 @@ def test_user_chooses_category
    end

    def test_user_skips_entering_category
 -    cat3 = Category.find_or_create("Cereal")
 +    cat3 = Category.find_or_create_by(name: "Cereal")
      shell_output = ""
      IO.popen('./grocerytracker add Cheerios --calories 210 --price 1.50 --environment test', 'r+') do |pipe|
        pipe.puts ""
 @@ -50,7 +50,7 @@ def test_valid_purchase_information_gets_printed
    def test_valid_purchase_gets_saved
      execute_popen("./grocerytracker add Cheerios --calories 210 --price 1.50 --environment test")
      purchase = Purchase.all.first
 -    expected = ["Cheerios", 210, "1.50"]
 +    expected = ["Cheerios", 210, 1.50]

#####test/test_putchases_are_imported_fully
def test_purchases_are_imported_fully
     import_data
     expected = [
-      "Corn Flakes, 4.00, 3000, Cereals",
-      "Panera Sandwich, 4.00, 450, Prepared Meals",
-      "Panera Soup, 5.50, 450, Soups",
-      "Rice Krispies, 3.40, 2000, Cereals",
+      "Corn Flakes, 4.0, 3000, Cereals",
+      "Panera Sandwich, 4.0, 450, Prepared Meals",
+      "Panera Soup, 5.5, 450, Soups",
+      "Rice Krispies, 3.4, 2000, Cereals",
     ]
     actual = Purchase.all.map do |product|
       "#{product.name}, #{product.price}, #{product.calories}, #{product.category.name}"
@@ -31,8 +31,8 @@ def test_extra_categories_arent_created
   end

   def test_categories_are_created_as_needed
-    Category.find_or_create("Cereals")
-    Category.find_or_create("Pets")
+    Category.find_or_create_by(name: "Cereals")
+    Category.find_or_create_by(name: "Pets")
     import_data
     assert_equal 4, Category.all.count, "The categories were: #{Category.all.map(&:name)}"
   end

#####test/test_purchase.rb
-    expected = ["Bar", "2.50", 20 ]
 +    expected = ["Bar", 2.50, 20 ]

    def test_save_saves_category_id
 -    category = Category.find_or_create("Meats")
 +    category = Category.find_or_create_by(name: "Meats")
      purchase = Purchase.create(name: "Foo", price: "1.50", calories: "10", category: category)
      category_id = Purchase.find(purchase.id).category.id
      assert_equal category.id, category_id, "Category.id and purchase.category_id should be the same"
    end

    def test_save_update_category_id
 -    category1 = Category.find_or_create("Meats")
 -    category2 = Category.find_or_create("Veggies")
 +    category1 = Category.find_or_create_by(name: "Meats")
 +    category2 = Category.find_or_create_by(name: "Veggies")
      purchase = Purchase.create(name: "Foo", price: "1.50", calories: "10", category: category1)
      purchase.category = category2
      purchase.save
 @@ -79,12 +79,8 @@ def test_save_update_category_id
      assert_equal category2.id, category_id, "Category2.id and purchase.category_id should be the same"
    end

 -  def test_find_returns_nil_if_unfindable
 -    assert_nil Purchase.find(12342)
 -  end
 -
    def test_find_returns_the_row_as_purchase_object
 -    category = Category.find_or_create("Things")
 +    category = Category.find_or_create_by(name: "Things")
      purchase = Purchase.create(name: "Foo", price: "1.50", calories: "10", category: category)
      found = Purchase.find(purchase.id)
      # Ideally: assert_equal purchase, found
 @@ -96,7 +92,7 @@ def test_find_returns_the_row_as_purchase_object
    end

    def test_find_returns_the_purchase_with_correct_category
 -    category = Category.find_or_create("Things")
 +    category = Category.find_or_create_by(name: "Things")
      purchase = Purchase.create(name: "Foo", price: "1.50", calories: "10", category: category)
      found = Purchase.find(purchase.id)
      refute_equal Category.default.id, found.category.id


############# Her commit ######################################
######### Refactor editing purchases into a method ###################

####grocerytracker
@@ -27,17 +27,21 @@ class GroceryTracker
      elsif command == "list"
        list_purchases()
      elsif command == "edit"
 -      if purchase = Purchase.find_by(id: options[:id])
 -        purchase.update(options)
 -        puts "Purchase #{purchase.id} is now named #{purchase.name}, with #{purchase.calories} calories and #{purchase.formatted_price} cost."
 -      else
 -        puts "Purchase #{options[:id]} couldn't be found."
 -      end
 +      edit_purchase()
      else
        puts "Command not implemented"
      end
    end

 +  def edit_purchase()
 +    if purchase = Purchase.find_by(id: options[:id])
 +      purchase.update(options)
 +      puts "Purchase #{purchase.id} is now named #{purchase.name}, with #{purchase.calories} calories and #{purchase.formatted_price} cost."
 +    else
 +      puts "Purchase #{options[:id]} couldn't be found."
 +    end
 +  end

