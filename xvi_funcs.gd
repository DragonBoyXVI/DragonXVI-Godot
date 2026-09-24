@abstract
@tool
extends Object;
class_name XVIFuncs;
## Global class with some useful functions.
##
## Destription 2 waow.


## Sets ALL node processes to enabled or disabled, dependig on whats given to
## the "enabled" argument.
## By default, this will disable all processes.
static func set_node_processes( node: Node, enabled: bool = false ) -> void:
	
	node.set_process( enabled );
	node.set_physics_process( enabled );
	node.set_process_input( enabled );
	node.set_process_shortcut_input( enabled );
	node.set_process_unhandled_input( enabled );
	node.set_process_unhandled_key_input( enabled );

## A neat wrapper for the threading functions in [ResourceLoader].
## A standardized way to load a resource on a thread using await.
##
## All of the arguments are the same as the resource loader thread ones, including the progress array.
static func load_resource_coroutine( resource_path: String, type_hint: String = "", progress: Array[ float ] = [] ) -> Resource:
	assert( ResourceLoader.exists( resource_path ), " Resource doesn't exist: %s" % resource_path );
	
	var error := ResourceLoader.load_threaded_request( resource_path, type_hint );
	if ( error != OK ):
		push_error( "Could not load resource %s on thread: %s" % [ resource_path, error_string( error ) ] );
		return null;
	
	while true:
		var load_status := ResourceLoader.load_threaded_get_status( resource_path, progress );
		if ( load_status == ResourceLoader.THREAD_LOAD_LOADED ):
			break;
		elif ( load_status == ResourceLoader.THREAD_LOAD_IN_PROGRESS ):
			await ( Engine.get_main_loop() as SceneTree ).process_frame;
		else:
			return null;
	
	return ResourceLoader.load_threaded_get( resource_path );

## Converts a bpm value into a period of time measured in seconds.[br]
## Example: 120 bpm == 0.5 seconds
static func bpm_to_sec( bpm: float ) -> float:
	return bpm / 60.0;

## Does what bpm_to_sec does, but backwards.
static func sec_to_bpm( sec: float ) -> float:
	return 60.0 / sec;
