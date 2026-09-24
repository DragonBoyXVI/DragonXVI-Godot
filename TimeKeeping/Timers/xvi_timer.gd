@abstract
@tool
extends Timer;
class_name XVITimer;
## Base timer class for properties and funcs that all custom timers share.
##
## Does nothing on its own.


const _TIMER_RANGE_EXPORT := "0.001,4096.0,0.001,or_greater,exp_easing";


## Same as the autostart in the timer class, but i have more control over this one,
## If true, the timer starts itself when in the tree.
@export var start_automatically: bool = false;


## The rng object this should use.
## If not provided, this uses the global random functions.
var rng: RandomNumberGenerator = null;


func _init() -> void:
	
	timeout.connect( _on_self_timeout );

func _validate_property( property: Dictionary ) -> void:
	const DISABLED: PackedStringArray = [
		"wait_time",
		"autostart"
	];
	
	if ( property[ Property.NAME ] in DISABLED ):
		property[ Property.USAGE ] = PROPERTY_USAGE_NONE;

func _enter_tree() -> void:
	
	if ( Engine.is_editor_hint() ):
		return;

	if ( start_automatically ):
		start_ext.call_deferred();


## This is the function youre meant to call to start the special timer logic.[br]
@abstract func start_ext() -> void;


func _on_self_timeout() -> void:
	if ( not one_shot ):
		start_ext();
