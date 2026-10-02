@tool
extends Node;
class_name FocusNodeOnVisible;


## Node this pays attention to.
@export var control: Control:
	set( new ):
		control = new;
		update_configuration_warnings();


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray();
	
	if ( not control ):
		warnings.append( "This inst watching a valid Control node!" );
	elif ( control.get_focus_mode_with_override() == Control.FOCUS_NONE ):
		warnings.append( "This node isnt focusable!!" );
	
	return warnings;


func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		return;
	
	control.visibility_changed.connect( _on_control_visibility_changed, CONNECT_DEFERRED );


func _on_control_visibility_changed() -> void:
	if ( control.is_visible_in_tree() ):
		control.grab_focus();
