@tool
extends XVITimer;
class_name RandomRangeTimer;
## Supply this with a min and max time and this will pick a random time between
## the two when started.
##
## If supplied with a [RandomNumberGenerator], this will use that.


## The longest amount of time this can be set for.
@export_range( 0.001, 4096.0, 0.001, "or_greater", "exp" ) var max_random_time: float = 2.0:
	set( new ):
		max_random_time = maxf( min_random_time, new );
## The shortest amount of time this can be set for.
@export_range( 0.001, 4096.0, 0.001, "or_greater", "exp" ) var min_random_time: float = 1.0:
	set( new ):
		min_random_time = minf( max_random_time, new );
		if ( Engine.is_editor_hint() ):
			wait_time = new;


func start_ext() -> void:
	if ( rng ):
		start( rng.randf_range( min_random_time, max_random_time ) );
	else:
		start( randf_range( min_random_time, max_random_time ) );
