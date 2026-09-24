@abstract
@tool
extends Area2D;
class_name StrippedArea2D;
## An [Area2D] with some properties disabled, so that they can be enabled
## in code instead.
##
## NOTE: Disabled properties are set to whatever is its OFF state,
## so you have to explicitly turn them back on.
## NOTE: Call super() in _init()!!!


func _init() -> void:
	
	monitoring = false;
	monitorable = false;
	collision_layer = 0;
	collision_mask = 0;
	input_pickable = false;
	
	if ( Engine.is_editor_hint() ):
		child_entered_tree.connect( _on_child_entered_tree );

func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		
		XVIFuncs.set_node_processes( self, false );
		return;

func _validate_property( property: Dictionary ) -> void:
	const DISABLED: PackedStringArray = [
		"monitoring",
		"monitorable",
		"collision_layer",
		"collision_mask",
		"input_pickable",
		"z_index",
	];
	
	if ( DISABLED.has( property[ Property.NAME ] ) ):
		property[ Property.USAGE ] = PROPERTY_USAGE_NONE;


## Runs in the editor only.
## is used for the _shape_entered_tree call.
func _on_child_entered_tree( node: Node ) -> void:
	
	if ( node is CollisionShape2D ):
		_shape_entered_tree( node );

## Virtual[br]
## Shortcut for when a [CollisionShape] child enters the tree.
## I like to use this to change the debug color automatically.
func _shape_entered_tree( _shape: CollisionShape2D ) -> void:
	pass
