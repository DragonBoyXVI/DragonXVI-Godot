@tool
@abstract
extends Button;
class_name HapiticButton;
## Button class with hapitic feedback funcs built in.
##
## Press my button oughhhhhh


func _init() -> void:
	
	if ( Engine.is_editor_hint() ):
		pass;
	
	offset_transform_enabled = true;
	
	focus_entered.connect( _on_focus_entered );
	focus_exited.connect( _on_focus_exited );
	button_up.connect( _on_button_up );
	button_down.connect( _on_button_down );


func _on_focus_entered() -> void:
	pass

func _on_focus_exited() -> void:
	pass

func _on_button_down() -> void:
	pass

func _on_button_up() -> void:
	pass
