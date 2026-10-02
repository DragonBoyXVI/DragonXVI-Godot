@tool
@abstract
extends Object;
class_name CmdlineParser;
## automaticallt parses any arguments given via the command line.
## You can then check for the existance of or get values from those arguments.
##
## When adding new arguments to check for, youd do best to just extend this script in a new script,
## as this already provides some baseline arguments that i use.


## Unlocks developer features.
const DEV_MODE := "--dev";


static var _cmd_args: Dictionary[ String, String ] = {};


static func _static_init() -> void:
	
	print( "cmd init" );
	var arguments := OS.get_cmdline_args();
	
	for i: int in arguments.size():
		var argument_string: String = arguments[ i ];
		
		if ( !argument_string.begins_with( "--" ) ):
			continue;
		
		if ( i < arguments.size() - 1 ):
			var next_string: String = arguments[ i + 1 ];
			if ( !next_string.begins_with( "--" ) ):
				_cmd_args[ argument_string ] = arguments[ i + 1 ];
				continue;
		
		if ( "=" in argument_string ):
			var values := argument_string.split( "=" );
			_cmd_args[ values[ 0 ] ] = values[ 1 ];
			continue;
		
		_cmd_args[ argument_string ] = "";
	
	print( _cmd_args );


## Returns true if the game was provided with that argument.
static func has_arg( arg: String ) -> bool:
	return arg in _cmd_args;

## Returns a string that represents the value provided to that argument.
## Returns the fallback if no value was given.
static func get_arg_value( arg: String, fallback: String = "" ) -> String:
	
	if ( arg in _cmd_args ):
		return _cmd_args[ arg ];
	
	return fallback;
