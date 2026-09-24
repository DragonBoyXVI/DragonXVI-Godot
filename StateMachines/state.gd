@abstract
@icon( "uid://co7j8ckrp6x72" )
extends Node;
class_name State;
## A State node based in GDScript
##
## A state template thats compatable with a [GDStateMachine] node.


## Used to tell the parent [GDStateMachine] to change states.
signal state_change_requested( state: StringName );
## Used to tell the parent [GDStateMachine] to change states.
func emit_state_change_request( state: StringName ) -> void:
	state_change_requested.emit( state );


## Virtual function for when this state is entered
func _enter_state() -> void:
	pass;

## Virtual function for when this state is left
func _leave_state() -> void:
	pass;

## Virtual for if this state can swap into a new state.
## By default, this stops states from transitioning into themselves.
func _can_switch_state( state: State ) -> bool:
	return name != state.name;

## States are enabled when they become the current state
func _enable() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT;

## States are disabled when not the current state
func _disable() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED;
