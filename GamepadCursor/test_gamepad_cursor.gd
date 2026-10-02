@tool
extends Control;
class_name TestGamepadCorsor;


var _is_mouse_mode := false;


func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		
		XVIFuncs.set_node_processes( self, false );
		return;
	
	#get_tree().root.gui_focus_changed
	
	#Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;

func _process( delta: float ) -> void:
	
	var input_vector := Input.get_vector( "ui_left", "ui_right", "ui_up", "ui_down" );
	if ( input_vector.is_zero_approx() ):
		return;
	_is_mouse_mode = false
	
	if ( _is_mouse_mode ): return;
	
	const SPEED := 500.0;
	position += input_vector * SPEED * delta;
	position = position.clamp( Vector2.ZERO, get_viewport_rect().size );
	Input.warp_mouse( global_position );

func _input( event: InputEvent ) -> void:
	if ( event.is_echo() ): return;
	
	if ( event is InputEventMouseMotion ):
		
		_is_mouse_mode = true;
		global_position = event.global_position;

func _draw() -> void:
	
	draw_circle( Vector2.ZERO, 1.0, Color.RED );
	draw_circle( Vector2.ZERO, 4.0, Color.BLUE, false );
