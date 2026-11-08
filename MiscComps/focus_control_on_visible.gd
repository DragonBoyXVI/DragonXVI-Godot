@tool
extends Node;
class_name FocusNodeOnVisible;


## Node this pays attention to.
@export var _control: Control:
	set( new ):
		_control = new;
		update_configuration_warnings();


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray();
	
	if ( not _control ):
		warnings.append( "This inst watching a valid Control node!" );
	elif ( _control.get_focus_mode_with_override() == Control.FOCUS_NONE ):
		warnings.append( "This node isnt focusable!!" );
	
	return warnings;


func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		return;
	
	_control.visibility_changed.connect( _on_control_visibility_changed, CONNECT_DEFERRED );


func _on_control_visibility_changed() -> void:
	if ( _control.is_visible_in_tree() ):
		_control.grab_focus();
