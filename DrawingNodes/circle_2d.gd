@tool
extends Drawing2D
class_name CircleDrawing2D
## Draws a circle
##
## Basically draws two circles bc of the outine lol.


## Radius of the circle.
## not affected by outline thickness.
@export var radius: float = 32.0:
	set( new ):
		
		radius = maxf( 1.0, new )
		queue_redraw()
## offset from the center of the circle
@export var offset: Vector2 = Vector2.ZERO:
	set( new ):
		
		offset = new
		queue_redraw()


func _draw() -> void:
	if ( draw_flags == 0 ):
		return
	
	var antialiasing := bool( draw_flags & DrawFlag.ANIALIASING );
	
	if ( draw_flags & DrawFlag.CENTER ):
		draw_circle( offset, radius, center_color, true, -1.0, antialiasing );
	if ( draw_flags & DrawFlag.OUTLINE ):
		draw_circle( offset, radius, outline_color, false, outline_thickness, antialiasing );
