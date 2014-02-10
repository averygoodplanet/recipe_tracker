class CreateRecipes < ActiveRecord::Migration
    def change
      create_table :recipes do |t|
        t.string :recipe_name
        t.string :ingredients
        t.string :directions
        t.integer :time
        t.string :meal
        t.integer :serves
        t.integer :calories
      end
    end
end