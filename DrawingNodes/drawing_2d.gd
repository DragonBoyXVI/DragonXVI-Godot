@abstract
@tool
extends Node2D;
class_name Drawing2D;
## Base class for drawing shapes
##
## Base class for nodes that draw some simple shapes to the screen.
## Provides some data related to how those are drawn.


const HANDLE_COLOR := Color.ORANGE;


## Flags for what to draw.
enum DrawFlag {
	## Draw outline
	OUTLINE = 1<<0,
	## Draw filled center
	CENTER = 1<<1,
	## Enables antialiasing
	ANIALIASING = 1<<2,
}

@export_group( "Outline", "outline_" )
## How many pixels thick the outline is
@export var outline_thickness: float = 3.0:
	set( new ):
		
		outline_thickness = new;
		queue_redraw();
## color of the outline
@export var outline_color: Color = Color.BLACK:
	set( new ):
		
		outline_color = new;
		queue_redraw();
@export_group( "Center", "center_" )
## Color of the shape center
@export var center_color: Color = Color.WHITE:
	set( new ):
		
		center_color = new;
		queue_redraw();
## Flags for what to draw.
@export_flags( 
	"Draw Outline", 
	"Draw Center", 
	"Antialiasing" ) var draw_flags: int = DrawFlag.OUTLINE | DrawFlag.CENTER:
	set( new ):
		
		draw_flags = new;
		notify_property_list_changed();
		queue_redraw();


func _validate_property( property: Dictionary ) -> void:
	const OUTLINE_NAMES: PackedStringArray = [
		"outline_thickness",
		"outline_color",
	];
	const CENTER_NAMES: PackedStringArray = [
		"center_color",
	];
	
	if (property[Property.NAME] in OUTLINE_NAMES):
		if (not draw_flags & DrawFlag.OUTLINE):
			property[Property.USAGE] = PROPERTY_USAGE_NONE;
	elif (property[Property.NAME] in CENTER_NAMES):
		if (not draw_flags & DrawFlag.CENTER):
			property[Property.USAGE] = PROPERTY_USAGE_NONE;
