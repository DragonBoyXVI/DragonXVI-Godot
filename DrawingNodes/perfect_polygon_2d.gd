@tool
extends CircleDrawing2D
class_name PerfectPolygon2D
## Draws a multi point polygon, like pentagons.
##
## Does not provide any of the functionality actual polygon nodes do,
## this is purely for the shapes themselvs.[br]
## increase the points enough and you loop back around to a shitty circle lol.


## How many points the polygon has
@export var points: int = 5:
	set( new ):
		
		points = maxi( 3, new )
		queue_redraw()


func _draw() -> void:
	if ( draw_flags == 0 ):
		return;
	
	var point_array: PackedVector2Array = [];
	point_array.resize( points );
	for i: int in points:
		var angle: float = ( float( i ) / points ) * TAU;
		var vector := Vector2.from_angle( angle );
		vector *= radius;
		point_array[ i ] = vector;
	
	var antialiasing := bool( draw_flags & DrawFlag.ANIALIASING );
	
	if ( draw_flags & DrawFlag.CENTER ):
		draw_colored_polygon( point_array, center_color );
	
	if ( draw_flags & DrawFlag.OUTLINE ):
		
		var line_points := PackedVector2Array( point_array )
		line_points.append( line_points[ 0 ] )
		draw_polyline( line_points, outline_color, outline_thickness, antialiasing );
