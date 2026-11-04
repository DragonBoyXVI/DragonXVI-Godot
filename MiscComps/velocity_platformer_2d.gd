@tool
extends Node;
class_name VelocityPlatformer2D;
## Gives generic velocity control similar to that of a side scroller.
##
## For the most part this acts like it only works on one axis, the x.
## Add more components that affect this's velocity?


enum Direction {
	STOP,
	LEFT,
	RIGHT,
}


@export_group( "Speed" )

## The highest speed this can reach without modifiers.
@export_range( 0.0, 2000.0, 1.0, "or_greater" ) var max_velocity: float = 800.0;
## How many pix/sec this accelerates with.
## A higher value feels more responsive, and a lower one more slippery.
@export_range( 0.0, 5000.0, 1.0, "or_greater" ) var acceleration: float = 3000.0;
## How many pix/sec this slows down.
## A higher value feels more responsive, and a lower one more slippery.
@export_range( 0.0, 5000.0, 1.0, "or_greater" ) var deceleration: float = 4000.0;


var _current_velocity: Vector2 = Vector2.ZERO;


## Returns the direction of the current velocity as if we're moving on the ground.
func get_velocity_ground_direction() -> Direction:
	
	if ( is_zero_approx( _current_velocity.x ) ):
		return Direction.STOP;
	
	return Direction.RIGHT if _current_velocity.x > 0.0 else Direction.LEFT;


func decelerate( delta: float ) -> void:
	
	var velocity_delta: float = delta * deceleration;
	_current_velocity = _current_velocity.move_toward( Vector2.ZERO, velocity_delta );

func accelerate( delta: float, target_velocity: float ) -> void:
	pass;


func accelerate_in_direction( delta: float, direction: Direction ) -> void:
	
	if ( direction == Direction.STOP ):
		decelerate( delta );
		return;
	
	if ( get_velocity_ground_direction() != direction ):
		decelerate( delta );
		return;
