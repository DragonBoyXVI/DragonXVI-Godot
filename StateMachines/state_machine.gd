@icon( "uid://d1tih0h8h2lhj" )
@tool
extends Node;
class_name StateMachine;
## A GDScript based state machine
##
## Root of a node based state machine, can have many [StateGD] children
## that it manages.


## Emitted when a state is entered
signal state_entered( state: State );
## Emitted when a state is left
signal state_left( state: State );


## What state this starts on when readied
@export var _initial_state: State:
	set( new ):
		_initial_state = new;
		update_configuration_warnings();


var _current_state: State;
## Keep child states here
var _state_cache: Dictionary[ StringName, State ] = {}


func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		
		XVIFuncs.set_node_processes( self, false );
		return;
	
	var children := get_children()
	for child: Node in children:
		if ( child is State ):
			_register_state( child )
	
	if ( _initial_state ):
		change_state( _initial_state.name )

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray();
	
	if ( not _initial_state ):
		warnings.append( "No initial state set! Without one, this machine will not work unless set via some other means." );
	
	return warnings;


## Used to ready a state for usage in the ready func
func _register_state( state: State ) -> void:
	
	if ( _state_cache.has( state.name ) ):
		push_error( "Attempting to add dupe state: ", state.name )
		return
	
	_state_cache[ state.name ] = state
	state._disable()
	state.state_change_requested.connect( _on_state_change_requested )

## Changes the current state
func change_state( state_name: StringName ) -> void:
	
	if ( not _state_cache.has( state_name ) ):
		push_error( "Trying to enter invalid state: ", state_name )
		return
	
	var new_state: State = _state_cache[ state_name ]
	
	if ( _current_state ):
		if ( not _current_state._can_switch_state( new_state ) ):
			return
		
		_current_state._leave_state()
		_current_state._disable()
		state_left.emit( _current_state )
	
	_current_state = new_state
	_current_state._enable()
	_current_state._enter_state()
	state_entered.emit( _current_state )


func _on_state_change_requested( state: StringName ) -> void:
	change_state( state )
