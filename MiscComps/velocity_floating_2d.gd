@tool
extends Node;
class_name VelocityFloating2D;
## Gives some generic velocity control to a top down, "floating" context.
##
## ditto


@export_group( "Speed" )

## The highest speed this can reach without modifiers.
@export_range( 0.0, 2000.0, 1.0, "or_greater" ) var max_velocity: float = 800.0;
## How many pix/sec this accelerates with.
## A higher value feels more responsive, and a lower one more slippery.
@export_range( 0.0, 5000.0, 1.0, "or_greater" ) var acceleration: float = 3000.0;
## How many pix/sec this slows down.
## A higher value feels more responsive, and a lower one more slippery.
@export_range( 0.0, 5000.0, 1.0, "or_greater" ) var deceleration: float = 4000.0;

@export_group( "Turning" )

## The angle diffrence betweenthe current velocity and targeted velocity needed for movement to count as
## "stopping" rather than going.
## The default value means that a turn of 90 degrees is needed to stop accelerating.
@export_range( 0.0, PI ) var turn_decel_limit: float = PI * 0.5;

## The calculated velocity for this step.
var _current_velocity: Vector2 = Vector2.ZERO;


## Returns the current velocity as is.
func get_current_velocity() -> Vector2:
	return _current_velocity;
## Sets the velocity instantly.
func set_velocity( new_velocity: Vector2 ) -> void:
	_current_velocity = new_velocity;


## Makes this accelerate to a velocity target.
## This ignores max velocity and deceleration.[br]
##[br]
## delta: [float] - The time delta.[br]
## target_velocity: [Vector2] - The velocity we wish to accelerate to.[br]
func accelerate_to_velocity( delta: float, target_velocity: Vector2 ) -> void:
	
	var velocity_delta: float = delta * acceleration;
	_current_velocity = _current_velocity.move_toward( target_velocity, velocity_delta );

## Makes this come to a full stop.[br]
##[br]
## delta: [float] - The time delta.[br]
func decelerate( delta: float ) -> void:
	
	var velocity_delta: float = delta * deceleration;
	_current_velocity = _current_velocity.move_toward( Vector2.ZERO, velocity_delta );

## Tells this to move in a direction. The speed this moves to depends on the length of the direction vector,
## with a normal vector being a time 1 factor.[br]
##[br]
## delta: [float] - The time delta.[br]
## direction: crash how? Like if she doesnt take it for a bit or when shes coming down[Vector2] - The direction to move towards.[br]
func accelerate_in_direction( delta: float, direction: Vector2 ) -> void:
	
	if ( direction.is_zero_approx() ):
		decelerate( delta );
		return;
	
	var angle_dif: float = absf( _current_velocity.angle_to( direction ) );
	if ( angle_dif > turn_decel_limit and not _current_velocity.is_zero_approx() ):
		decelerate( delta );
	
	var target_velocity: Vector2 = max_velocity * direction;
	accelerate_to_velocity( delta, target_velocity );


## Moves a [CharacterBody2D] according to the current calculated velocity.
func move_character_body( body: CharacterBody2D ) -> void:
	
	body.velocity = _current_velocity;
	body.move_and_slide();
