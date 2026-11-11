@tool
extends Node;
class_name HealthNode;
## Generic health node.
## Holds a health value and emits updates when that health changes.
##
## Uses floats, if you want integers just always send it whole numbers lmao.


## Encapsulated health update.
class HealthUpdate:
	extends RefCounted;
	# try to keep as few vars on here as possible.
	
	## How much health this had before the change.
	var previous_health: float = 0.0;
	## How much health this has after the update.
	var current_health: float = 0.0;
	## Up to date max health value.
	var max_health: float = 0.0;
	
	func _to_string() -> String:
		const FORMAT := "Prev: %f, Current: %f, Max: %f";
		
		return FORMAT % [ previous_health, current_health, max_health ];
	
	## Returns true if this was a healing event.
	func is_heal() -> bool:
		return get_health_difference() > 0.0;
	
	## Returns true if this was a damaging event.
	func is_damage() -> bool:
		return get_health_difference() < 0.0;
	
	## Returns the previous health percentage.
	func get_previous_percent() -> float:
		return previous_health / max_health;
	
	## Returns the current health percentage.
	func get_current_percent() -> float:
		return current_health / max_health;
	
	## Returns the difference between the previous and current health.[br]
	## current_health - previous_health.
	func get_health_difference() -> float:
		return current_health - previous_health;
	
	## Returns true if this event was fatal.
	func is_fatal() -> bool:
		return ( current_health <= 0.0 and previous_health > 0.0 );
	
	## Returns true if this event undid a fatal health state.
	func is_revive() -> bool:
		return ( current_health > 0.0 and previous_health <= 0.0 );


## Emitted when health info changes.
signal health_changed( health_update: HealthUpdate );


## If true, the current health value may go negative.
@export var _negatives_allowed: bool = true;
## Maximum health this can have.
@export var _max_health: float = 5.0:
	set( new ):
		_max_health = maxf( 1.0, new );

var _current_health: float = 0.0;


func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		
		XVIFuncs.set_node_processes( self, false );
		return;
	
	_current_health = _max_health;


# use this as much as possible.
## Sets the current health value.
func set_health( value: float ) -> void:
	var update := HealthUpdate.new();
	
	update.max_health = _max_health;
	update.previous_health = _current_health;
	
	if ( _negatives_allowed ):
		_current_health = minf( value, _max_health );
	else:
		_current_health = clampf( value, 0.0, _max_health );
	
	update.current_health = _current_health;
	health_changed.emit( update );

## Sets the current health value as a percent of its max.[br]
## Give a value from 0.0 to 1.0.
func set_health_percent( percent: float ) -> void:
	set_health( _max_health * percent );

## Forces this to emit a health update.
func force_update() -> void:
	damage( 0.0 );

## Reduces health by a value.
func damage( damage_amount: float ) -> void:
	set_health( _current_health - damage_amount );

## Restores an amount of health.
func heal( heal_amount: float ) -> void:
	set_health( _current_health + heal_amount );


## Returns the current health value.
func get_health() -> float:
	return _current_health;

## Returns the current max health value.
func get_max_health() -> float:
	return _max_health;

## Gets the current health percent.
func get_health_percent() -> float:
	return _current_health / _max_health;

## Sets a new max health value.
func set_max_health( value: float ) -> void:
	
	_max_health = value;
	set_health( _current_health );
