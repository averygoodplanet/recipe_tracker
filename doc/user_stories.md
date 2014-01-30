User Stories
========

Save a Recipe (C in CRUD)
--------------------

As  a user, I want to be able to save a new recipe to the database so that I can use
it in the future.

Usage:  ./recipe_tracker create "Ham Sandwich" --ingredients "ham, cheese, bread"
 --directions "put between bread" --time 20 --meal "Entree" --serves 5 --calories
 40

Acceptance Criteria:
* Prompts user to enter new recipe data
* Correctly saves the recipe data to the database


Find and View a Recipe By Name (R in CRUD)
-----------------------------------

As a user, I want to be able to search for and view a recipe by name, so that I can
then use that recipe.

Usage: ./recipe_tracker view "Potato Salad"

Acceptance Criteria:
* Returns exact match of searched name, if found.
* If no match found, gives message that no matches found.


Update a Recipe (U in CRUD)
----------------------

As a user, I want to be able to make changes to a recipe that is already saved in
the database.

Usage: ./recipe_tracker edit "Ham Sandwich" --name "Prosciutto Sandwich"
ingredients "prosciutto, cheese, bread" --calories 60

Acceptance Criteria:
* Prompts user to enter modified data
* Correctly updates the recipe in the database

Delete a Recipe By Name (D in CRUD)
-----------------------------

As a user, I want to be able to delete a recipe from the database, so that I can
remove recipes that I don't like or no longer want to use.

Usage: ./recipe_tracker delete "Lima Bean Casserole"

Acceptance Criteria:
* Prompt user to confirm whether they really want to delete the recipe.
* After user confirmation, delete the recipe from the database.


Import Entries from a CSV file into the Database
--------------------------------------

As a user, I want to be able to import recipes from a CSV, so that I don't have to
enter them all manually from the command line, one-by-one.

Usage: ./recipe_tracker import "example.csv"

Acceptance Criteria:
* Program locates the file in the data directory and then creates entries in the
database from each row in the CSV.


Search for Recipes by Max Calories
----------------------------

As a user, I want to be able to search for recipes under a certain number of calories.

Usage: ./recipe_tracker calories_under 600

Acceptance Criteria:
* Return recipes under the amount of calories indicated.


Show List of Recipes in Database
----------------------------

As a user, I want to be able to page through a list of names of recipes in the
database, so that later I can retrieve a recipe by name.

Usage: ./recipe_tracker all

Acceptance Criteria:
* Lists all recipes in alphabetical order
* If output extends beyond terminal height, scrolls output (similar to git log output).


Help Feature
-----------

As a user, I want the program to remind me of the available commands, so that
I don't have to try to remember them all.

 Usage: ./recipe_tracker --help

 Acceptance Criteria:
 * On typing 'help' command, provide a short list of each program command and
 what each command does.
