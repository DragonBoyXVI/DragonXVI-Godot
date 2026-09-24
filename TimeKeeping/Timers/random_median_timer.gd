@tool
extends XVITimer;
class_name RandomMedianTimer;
## Uses the randfn function to pick random times along a standard deviation.
## This makes for more natural feeling randomness, but be mindfull that extreme
## outliers are an (unlikely) possibility.
##
## Use an rng object to control its rng state.


## The median or "expected" amount of time.
## Picked wait time is deviated from here.
@export_range( 0.001, 4096.0, 0.001, "or_greater", "exp" ) var mean_time: float = 1.0:
	set( new ):
		mean_time = new;
		if ( Engine.is_editor_hint() ):
			wait_time = new * 0.5;
## The standard expected deviation from the mean.
@export var time_deviation: float = 0.125:
	set( new ):
		time_deviation = maxf( 0.001, absf( new ) );


func start_ext() -> void:
	if ( rng ):
		start( rng.randfn( mean_time, time_deviation ) );
	else:
		start( randfn( mean_time, time_deviation ) );
