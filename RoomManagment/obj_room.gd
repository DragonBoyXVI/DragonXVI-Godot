@tool
extends Node2D;
class_name ObjRoom2D;
## Base class for any type of room.
##
## Super specific desc here


func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		
		XVIFuncs.set_node_processes( self, false );
		return;
