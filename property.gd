@abstract
@tool
extends Object;
class_name Property;
## Helper class for property dictionaries, like those used for _validate_property.
##
## Now its own class for shorter code lines.


## Name of the property as used in code.
const NAME := &"name";
## String name of the BUILT in class. Only if the property type is TYPE_OBJECT.
const CLASS_NAME := &"class_name";
## The Variant.Type of this property.
const TYPE := &"type";
## Determines how the editor displays and edits this property.
const HINT := &"hint";
## Used with the hint.
const HINT_STRING := &"hint_string";
## How this property is used. E.g, a category rather than a property?
const USAGE := &"usage";
