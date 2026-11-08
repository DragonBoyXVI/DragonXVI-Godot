@tool
extends Resource;
class_name Pronoun;
## Wokot../.
##
## Please provide pronouns in lowercase, you should capitalize them as needed in your game.


## The name of the pronoun set.
## eg, She/Her/Hers.
@export_placeholder( "He/Him/His..." ) var pronoun_name: String = "";

## Refers to the subject directly.[br]
## "He went to the store."
@export_placeholder( "There he is..." ) var nominative: String = "";
## The subject did an action.[br]
## "I met him today."
@export_placeholder( "Thats him there..." ) var accusaive: String = "";
## Possesses an object.[br]
## "He walked his dog today."
@export_placeholder( "This book is his..." ) var pronominal_possessive: String = "";
## Possesses a previously mentioned object.[br]
## "If i need a book my friend will let me borrow his."
@export_placeholder( "This is his book..." ) var predicative_possessive: String = "";
## The subject refrences itself.[br]
## "He had to drive himself to school."
@export_placeholder( "Himself..." ) var reflexive_pronoun: String = "";
## Polite, not all pronouns use these. Leave this blank in that case.[br]
## "Excuse me Ma'am."
@export_placeholder( "Sir..." ) var vocacative: String = "";
