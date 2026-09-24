@abstract
@tool
extends Object;
class_name XVIControlAnimation;
## Global class that animates control nodes.
##
## ditto


## Metadata name for the tween used for animation.
## This tween is stored in the metadata of the provided node.
const _MTWEEN := &"CurrentTween";


## Util for killing active tweens.
static func _kill_tween( control: Control ) -> void:
	if ( control.has_meta( _MTWEEN ) ):
		var tween: Tween = control.get_meta( _MTWEEN );
		if ( tween and tween.is_running() ):
			tween.kill();


## Plays an animation like that of a closing computer window.
## Hides the node once the animation is finished.
static func close_window( control: Control, duration: float = 0.125 ) -> Tween:
	_kill_tween( control );
	control.offset_transform_enabled = true;
	
	var tween := control.create_tween();
	control.set_meta( _MTWEEN, tween );
	tween.set_ignore_time_scale();
	tween.set_pause_mode( Tween.TWEEN_PAUSE_PROCESS );
	tween.set_parallel();
	
	tween.tween_property( control, ^"modulate", Color.TRANSPARENT, duration );
	tween.tween_property( control, ^"offset_transform_scale", Vector2( 0.8, 0.8 ), duration );
	tween.tween_callback( control.hide ).set_delay( duration );
	
	return tween;

## Plays an animation like that of opening a computer window.[br]
## The "stage_node" argument will set the node to the expected state of a closed window (transparent, reduced scale). 
static func open_window( control: Control, stage_node: bool = true, duration: float = 0.125 ) -> Tween:
	_kill_tween( control );
	
	if ( stage_node ):
		
		control.offset_transform_scale = Vector2( 0.8, 0.8 );
		control.modulate = Color.TRANSPARENT;
	
	var tween := control.create_tween();
	control.set_meta( _MTWEEN, tween );
	tween.set_ignore_time_scale();
	tween.set_pause_mode( Tween.TWEEN_PAUSE_PROCESS );
	tween.set_parallel();
	
	tween.tween_property( control, ^"modulate", Color.WHITE, duration );
	tween.tween_property( control, ^"offset_transform_scale", Vector2.ONE, duration );
	tween.tween_callback( control.show );
	
	return tween;
