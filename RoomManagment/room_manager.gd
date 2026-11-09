@tool
extends Node2D;
class_name RoomManager2D;
## Handles loading new rooms upon request.
##
## ditto


signal room_changed( room: ObjRoom2D );


@export var _current_room: ObjRoom2D;
func get_curremt_room() -> ObjRoom2D:
	return _current_room;


## used to preserve the pause state when changing rooms.
var _is_room_paused: bool = false;


func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		
		XVIFuncs.set_node_processes( self, false );
		return;


## Changes the current room to the one at the file path.
func change_room( room_path: String ) -> void:
	
	var new_room_scene: PackedScene = load( room_path );
	change_room_to_scene( new_room_scene );
	
	room_changed.emit( _current_room );

## Same as normal change room, except the file is loaded on a thread.
func change_room_thread( room_path: String ) -> void:
	
	var new_room_scene: PackedScene = await XVIFuncs.load_resource_coroutine( room_path, "PackedScene" );
	change_room_to_scene( new_room_scene );
	
	room_changed.emit( _current_room );


func change_room_to_scene( room_scene: PackedScene ) -> void:
	assert( room_scene.can_instantiate() );
	
	if ( _current_room ):
		_current_room.queue_free();
	_current_room = room_scene.instantiate();
	if ( _is_room_paused ):
		_current_room.pause.call_deferred();
	add_child( _current_room );
	
	room_changed.emit( _current_room );


func pause_rooms() -> void:
	
	_is_room_paused = true;
	if ( _current_room ):
		XVIFuncs.node_set_enabled( _current_room, false, true )

func unpause_rooms() -> void:
	
	_is_room_paused = false;
	if ( _current_room ):
		XVIFuncs.node_set_enabled( _current_room, true, true )
