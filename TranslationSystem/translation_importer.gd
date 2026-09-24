@abstract
@tool
extends Object;
class_name TranslationImporter;


## The key checked for what locale the translation belongs to.
const LOCALE_CHECK := "locale";


## Contains extra translation data.
## eg. An array of text you can randomly pick from.
static var _extra_data: Dictionary[ String, Dictionary ] = {};


## This node stores any extra data that cant be stored in a translation.
## For example, your json can contain an array of strings, and this will
## store that here for you to grab later.
## Can return null if the extra data doesnt exist.
static func get_extra_data( key: String, locale: String = TranslationServer.get_locale() ) -> Variant:
	
	if ( not locale in _extra_data ):
		push_error( "Getting extra data for a locale we dont have! ", locale );
		return null;
	
	var data: Dictionary = _extra_data[ locale ];
	if ( not key in data ):
		push_error( "Getting extra data that we dont have! ", locale, " ", key );
		return null;
	
	return data[ key ];


## Loads a file and parses it as text, can be a file inside the "res" or outside.[br]
## if the file is a json that contains a valid dictionary, it gets parsed
## as a translation. Otherwise an error is printed and nothing happens.
## The dictionary is parsed via "parse_dict_to_translation"
static func parse_file_for_dict( path: String ) -> void:
	
	if ( not FileAccess.file_exists( path ) ):
		push_error( "Trying to translate a file that doesnt exist! ", path );
		return;
	
	var file := FileAccess.open( path, FileAccess.READ );
	if ( not file ):
		push_error( "Translation file open error! Path: ", path, " Error: ", error_string( FileAccess.get_open_error() ) );
		return;
	
	var file_string: String = file.get_as_text();
	var json_parsed: Variant = JSON.parse_string( file_string );
	if ( json_parsed == null ):
		push_error( "Translation file json parse failed! ", path );
		return
	
	if ( typeof( json_parsed ) == TYPE_DICTIONARY ):
		
		parse_dict_to_translation( json_parsed );
	else:
		
		push_error( "Translation file parsed, but the parsed type was not a Dictionary! ", path );
		return;

## Parses the provided dictionary into a translation,
## and adds it to the [TranslationServer].[br]
## NOTE: If this defines extra data that is already defined for that language,
## it will be overwritten by the most recent parse.[br]
## If the dict is invalid, nothing happens and an error is printed.
static func parse_dict_to_translation( translation_dict: Dictionary ) -> Translation:
	
	if ( not LOCALE_CHECK in translation_dict ):
		push_error( "Translation dict does not contain a locale key! Translations must have a \"", LOCALE_CHECK, "\" key." );
		return;
	
	var translation := Translation.new();
	var extra: Dictionary = {};
	for key: Variant in translation_dict.keys():
		
		# we can only add strings as keys
		if ( typeof( key ) != TYPE_STRING ):
			continue;
		
		var value: Variant = translation_dict[ key ];
		if ( typeof( value ) == TYPE_STRING ):
			
			translation.add_message( key, value );
		else:
			
			extra[ key ] = value;
	
	var locale: String = translation_dict[ LOCALE_CHECK ];
	translation.locale = locale;
	TranslationServer.add_translation( translation );
	_extra_data[ locale ] = extra;
	return translation;

## Searches the directory for translation jsons, and sends
## any that it finds into parse_file_for_dict.[br]
## By default, this recursivley searches all subfolders within a dir.
static func parse_dir_for_files( dir_path: String, search_subdirs: bool = true ) -> void:
	
	if ( dir_path[ dir_path.length() - 1 ] == "/" ):
		dir_path[ dir_path.length() - 1 ] = "";
		# beutiful.,.,
	
	if ( not DirAccess.dir_exists_absolute( dir_path ) ):
		push_error( "Trying to parse a non existant folder! ", dir_path );
		return;
	
	var dir := DirAccess.open( dir_path );
	if ( not dir ):
		push_error( "Failed to open folder: ", error_string( DirAccess.get_open_error() ) );
		return;
	
	dir.list_dir_begin();
	var file_name := dir.get_next();
	while not file_name.is_empty():
		
		if ( dir.current_is_dir() ):
			if ( search_subdirs ):
				parse_dir_for_files( dir.get_current_dir() + "/" + file_name );
		else:
			parse_file_for_dict( dir.get_current_dir() + "/" + file_name );
		
		#print( "Translation search: ", dir.get_current_dir() + "/" + file_name );
		
		file_name = dir.get_next();

## Same as "parse_dir_for_files" but it uses the [WorkerThreadPool]
## to load all found files.
## DANGER: Unfinished do not use!!!
static func parse_dir_with_worker_pool( dir_path: String, search_subdirs: bool = true ) -> void:
	
	if ( dir_path[ dir_path.length() - 1 ] == "/" ):
		dir_path[ dir_path.length() - 1 ] = "";
	
	var root_dir := DirAccess.open( dir_path );
	if ( not root_dir ):
		push_error( "Failed to open folder: ", error_string( DirAccess.get_open_error() ) );
		return;
	
	if ( search_subdirs ):
		for dir: String in root_dir.get_directories():
			parse_dir_with_worker_pool( dir, search_subdirs );
	
	var files_to_parse := root_dir.get_files();
	var _task := func( index: int ) -> void:
		pass
