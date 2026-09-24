@abstract
@tool
extends StaticBody2D;
class_name StrippedStaticBody2D;
## A [StaticBody2D] with some properties disabled, so that they can be enabled
## in code instead.
##
## NOTE: Some disabled properties are set to whatever is its OFF state,
## so you have to explicitly turn them back on.
## NOTE: Call super() in _init()!!!


func _init() -> void:
	
	collision_layer = 0;
	collision_mask = 0;
	input_pickable = false;

func _ready() -> void:

	if ( Engine.is_editor_hint() ):
		
		XVIFuncs.set_node_processes( self, false );
		return;

func _validate_property( property: Dictionary ) -> void:
	const DISABLED: PackedStringArray = [
		"collision_layer",
		"collision_mask",
		"input_pickable",
		"z_index",
	];
	
	if ( DISABLED.has( property[ Property.NAME ] ) ):
		property[ Property.USAGE ] = PROPERTY_USAGE_NONE;
