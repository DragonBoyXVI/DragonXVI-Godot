@tool
extends Node;
class_name StopWatch;
## A node that tracks passed time, can take laps, and returns data about those laps.
##
## Laps will always measure their own length. The stopwatch will measure all of their cumulative length.[br]
## Please note that real time measurement does not consider pausing the game.


const FACTOR_MILLISECOND := 0.001;


## A [RefCounted] object that carries lengths of time from a [StopWatch].
class StopWatchLap:
	extends RefCounted;
	
	## Length of this lap in real world seconds.
	var real_time_amount: float = 0.0;
	## Length of this lap in game world seconds.
	var game_time_amount: float = 0.0;
	
	func _to_string() -> String:
		const TEMPLATE := "StopWatchLap: Real time %s sec, Game time %s sec.";
		return TEMPLATE % [ real_time_amount, game_time_amount ];


## If true, game time is tracked from the physics step instead of the process step.
@export var track_delta_on_physics: bool = false;


var _is_started: bool = false;

var _real_start_time: int = 0;
var _game_time: float = 0.0;

var _laps: Array[ StopWatchLap ] = [];
var _master_lap: StopWatchLap;


func _process( delta: float ) -> void:
	if ( not track_delta_on_physics ):
		_game_time += delta;

func _physics_process( delta: float ) -> void:
	if ( track_delta_on_physics ):
		_game_time += delta;


## Reset and start the stopwatch.
func start() -> void:
	_is_started = true;
	
	_real_start_time = Time.get_ticks_msec();
	_game_time = 0.0;
	
	_laps = [];
	_master_lap = StopWatchLap.new();

## Stop tracking time.
## This creates a lap.
func stop() -> void:
	_is_started = false;
	track_lap();

## Returns true if this is started and tracking time.
func is_started() -> bool:
	return _is_started;

## Tracks the current amount of time as a lap.
func track_lap() -> StopWatchLap:
	if ( not _is_started ):
		push_error( "StopWatch: Trying to track a lap on a stopped stopwatch" );
		return null;
	
	var lap := StopWatchLap.new();
	
	lap.real_time_amount = ( Time.get_ticks_msec() - _real_start_time ) * FACTOR_MILLISECOND;
	lap.game_time_amount = _game_time;
	if ( not _laps.is_empty() ):
		
		var previous_lap: StopWatchLap = _laps[ _laps.size() - 1 ];
		lap.real_time_amount -= previous_lap.real_time_amount;
		lap.game_time_amount -= previous_lap.game_time_amount;
	
	_laps.append( lap );
	return lap;

## Returns all stored laps.
## Gets reset when the stopwatch starts again.
func get_laps() -> Array[ StopWatchLap ]:
	return _laps;

## Returns a lap that represents the total time tracked by this stopwatch.
func get_master_lap() -> StopWatchLap:
	var lap := StopWatchLap.new();
	
	lap.real_time_amount = ( Time.get_ticks_msec() - _real_start_time ) * FACTOR_MILLISECOND;
	lap.game_time_amount = _game_time;
	
	return lap;
