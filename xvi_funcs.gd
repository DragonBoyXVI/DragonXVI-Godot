@abstract
@tool
extends Object;
class_name XVIFuncs;
## Global class with some useful functions.
##
## NOTE: When making additional utilities for a new game, be sure to extend this class.
## Makes it easier to migrate new utils to this class and push those to other projects.


## A neat wrapper for the threading functions in [ResourceLoader].
## A standardized way to load a resource on a thread using await.[br]
## NOTE: eh.[br]
## [br]
## resource_path: [String] - String path to the resource we want to load.[br]
## type_hint: [String] - Optional type helper for [ResourceLoader].[br]
static func load_resource_coroutine( resource_path: String, type_hint: String = "" ) -> Resource:
	assert( ResourceLoader.exists( resource_path ), " Resource doesn't exist: %s" % resource_path );
	
	var error := ResourceLoader.load_threaded_request( resource_path, type_hint );
	if ( error != OK ):
		push_error( "Could not load resource %s on thread: %s" % [ resource_path, error_string( error ) ] );
		return null;
	
	while true:
		var load_status := ResourceLoader.load_threaded_get_status( resource_path );
		if ( load_status == ResourceLoader.THREAD_LOAD_LOADED ):
			break;
		elif ( load_status == ResourceLoader.THREAD_LOAD_IN_PROGRESS ):
			await ( Engine.get_main_loop() as SceneTree ).process_frame;
		else:
			return null;
	
	return ResourceLoader.load_threaded_get( resource_path );

## Shorthand for my method of disabling properties.[br]
## [br]
## disable_list: [PackedStringArray] - List of properties you want disabled.[br]
## property: [Dictionary] - The current property being checked.[br]
static func property_disable_by_list( disable_list: PackedStringArray, property: Dictionary ) -> void:
	if ( property[ Property.NAME ] in disable_list ):
		property[ Property.USAGE ] = PROPERTY_USAGE_NONE;

#region Node Processing

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

## When provided a focusable [Control], this makes that [Control] grabs focus and warps the mouse
## to its center.
static func control_focus_and_snap( control: Control ) -> void:
	assert( control.get_focus_mode_with_override() != Control.FOCUS_NONE, ">={" );
	
	control.grab_focus();
	Input.warp_mouse( control.get_rect().get_center() );

## Sets a nodes [Node.process_mode] to [Node.PROCESS_MODE_INHERIT] or [Node.PROCESS_MODE_DISABLED].[br]
## [br]
## node: [Node] - The affected node.[br]
## enabled: [bool] - If true, set to enabled/inherit. Else set to disable.[br]
## is_deffered: [Bool] - if true, deffers the call. True by default to prevent physics fuckups.
static func node_set_enabled( node: Node, enabled: bool, is_deffered: bool = true ) -> void:
	
	var mode: Node.ProcessMode = Node.PROCESS_MODE_INHERIT if enabled else Node.PROCESS_MODE_DISABLED;
	if ( is_deffered ):
		node.set_deferred( &"process_mode", mode );
	else:
		node.process_mode = mode;

#endregion Node Processing

#region Math

## Converts a bpm value into a period of time measured in seconds.[br]
## Example: 120 bpm == 0.5 seconds
static func bpm_to_sec( bpm: float ) -> float:
	return bpm / 60.0;

## Does what bpm_to_sec does, but backwards.[br]
## Example: 0.5 seconds == 120 bpm
static func sec_to_bpm( sec: float ) -> float:
	return 60.0 / sec;

#endregion Math

#region JSON

const _DEFAULT_PROPERTY_BLACKLIST: PackedStringArray = [
	"script",
	"resource_local_to_scene",
	"resource_path",
	"resource_name",
];
## Turns a [Resource] into a [JSON] string, ready to be stored externally.[br]
## [br]
## resource: [Resource] - The resource to convert.[br]
## include_metadata: [bool] - If true, object metadata is included. This included custom script uids.[br]
## blacklist: [PackedStringArray] - Specific properties to be ignored. By default this included the script and all "resource_*" properties.
static func resource_to_json( resource: Resource, include_metadata: bool = false, blacklist: PackedStringArray = _DEFAULT_PROPERTY_BLACKLIST ) -> String:
	
	var json_dict : Dictionary[ String, Variant ] = {};
	
	var property_list := resource.get_property_list();
	for property in property_list:
		var property_name : String = property[ Property.NAME ];
		
		if ( property_name in blacklist ):
			continue;
		
		if ( property_name.begins_with( "metadata" ) ):
			if ( !include_metadata ):
				continue;
		
		if ( not property[ Property.USAGE ] & PROPERTY_USAGE_STORAGE ):
			continue;
		
		var prop_value: Variant = resource.get( property_name );
		if ( prop_value == null ):
			continue;
		json_dict[ property_name ] = prop_value;
	
	return JSON.stringify( json_dict );

## Takes a [JSON] string and fills out the provided [Resource].[br]
## This doesnt check for values defined in the json not existing in the resource,
## if that happens, theyre parsed but ignored, unless Godot changes how "set" works.[br]
## [br]
## NOTE: This returns the same resource you put in, it doesnt duplicate it.[br]
## resource: [Resource] - The resource to get filled out.[br]
## json_string: [String] - The json string to parse.[br]
static func fill_resource_from_json( resource: Resource, json_string: String ) -> Resource:
	
	var property_dict: Dictionary = {};
	
	var json_parsed_data: Variant = JSON.parse_string( json_string );
	if ( json_parsed_data == null ):
		push_error( "XVIFuncs: JSON string not parsable!" );
		return null;
	if ( typeof( json_parsed_data ) != TYPE_DICTIONARY ):
		push_error( "XVIFuncs: JSON is not of correct type! Expected string got %s" % type_string( typeof( json_parsed_data ) ) );
		return null;
	property_dict = Dictionary( json_parsed_data );
	
	for key: Variant in property_dict:
		
		var key_type : int = typeof( key );
		if ( key_type != TYPE_STRING and key_type != TYPE_STRING_NAME ):
			continue;
		
		resource.set( key, property_dict[ key ] );
	
	return resource;

#endregion JSON

#region Strings

const _splashes: PackedStringArray = [
	"oobie gaboobie",
	"oopy goopy",
	"bababoey",
	"babagaboosh",
	"oh my googness",
	"WORSE THAN CRUCIFICTION?",
	"CATHOLIC BIBLE DOCTORS SAY YES",
	"its good to be a girlball!",
	
	"FAT FUCKING ASS",
	"it's like asking someone who's never seen a faggot to draw one; they'll get some things right but the big titties aren't there",
	"a single white tear runs down my leg - memorygarument",
	"lick the my ass - memoryargument",
	
	#"gork, make a list of all human races from palest to darkest",
	"RIP kamala haris hyena porn o7",
	"we can be togore tastic about gravity falls later",
	"micropenis gilbert gottfried",
	"infinitely thin with infinite surface area",
	"statistically unlikely",
	"Flea market montgomery",
	"dont be a slubber use a rubber",
	"i jerk off to sorting algorithms and cnc",
];
## Returns a random splash.
## These are usually inside jokes with my wife/friends =3
static func get_random_splash() -> String:
	return _splashes[ randi() % _splashes.size() ];

## Taken from the Godot documentation.[br]
## Takes a string with bbcode and completely strips it from the returned string.
## This does prevent the use of brackets however.
static func strip_bbcode( source: String ) -> String:
	
	var regex := RegEx.create_from_string( "\\[.+?\\]" );
	return regex.sub( source, "", true );

#endregion Strings
