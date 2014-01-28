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

Usage: ./recipe_tracker find "Potato Salad"

Acceptance Criteria:
* Returns exact match of searched name, if found.
* If no exact match is found, returns fuzzy matches of searched name, and asks
user to select one recipe to view.
* If no (exact or fuzzy) matches, gives message that no matches found and
urges user to check spelling, and indicates how to page through list of all recipe
names.


Update a Recipe (U in CRUD)
----------------------

As a user, I want to be able to make changes to a recipe that is already saved in
the database.

Usage: ./recipe_tracker edit "Ham Sandwich" --name "Prosciutto Sandwich"
ingredients "prosciutto, cheese, bread" --calories 60

Acceptance Criteria:
*Prompts user to enter modified data
*Correctly updates the recipe in the database

Delete a Recipe By Name (D in CRUD)
-----------------------------

As a user, I want to be able to delete a recipe from the database, so that I can
remove recipes that I don't like or no longer want to use.

Usage: ./recipe_tracker delete "Lima Bean Casserole"

Acceptance Criteria:
* Prompt user to confirm whether they really want to delete the recipe.
* After user confirmation, delete the recipe from the database.


Search for Recipes by Criteria (type, calorie, prep time)
-----------------------------------------------

As a user, I want to be able to search for recipes that meet my criteria, so that I
can quickly choose from recipes rather than searching through them manually.

Usage: ./recipe_tracker query "entree 500 20"

Acceptance Criteria:
* Return recipes matching the user's query of type, calorie (or less), and prep
time.

Show List of Recipes in Database
----------------------------

As a user, I want to be able to page through a list of names of recipes in the
database, so that later I can retrieve a recipe by name.

Usage: ./recipe_tracker page

Acceptance Criteria:
* Show message to user, indicating button to press to continue paging through
recipe names, and also indicating the button used to exit.
* Allows user to page through recipe names


Help Feature
-----------

As a user, I want the program to remind me of the available commands, so that
I don't have to try to remember them all.

 Usage: ./recipe_tracker help

 Acceptance Criteria:
 * On normal program screens place message indicating that typing 'help' will
 give the help feature.
 * On typing 'help' command, provide a short list of each program command and
 what each command does.
