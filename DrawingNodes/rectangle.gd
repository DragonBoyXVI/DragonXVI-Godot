@tool
extends Drawing2D
class_name RectangleDrawing2D
## draws a rectangle to the screen.
##
## Simple rectiod, sqare even...


## Size of the rectangle
@export var size: Vector2 = Vector2( 32.0, 32.0 ):
	set( new ):
		
		size = new.max( Vector2.ONE )
		queue_redraw()
## rectagle offset.
## If from_center is true, this is from the center,
## else its from the top left corner.
@export var offset: Vector2 = Vector2.ZERO:
	set( new ):
		
		offset = new
		queue_redraw()
## if turned off, the rectangle is drawn from the top left corner.
@export var from_center: bool = true:
	set( new ):
		
		from_center = new
		queue_redraw()


func _draw() -> void:
	if ( draw_flags == 0 ):
		return;
	
	var antialiasing := bool( draw_flags & DrawFlag.ANIALIASING );
	var rect := Rect2( offset, size );
	if ( from_center ):
		rect.position -= size * 0.5;
	
	if ( draw_flags & DrawFlag.CENTER ):
		draw_rect( rect, center_color, true, -1.0,  )
	
	if ( draw_flags & DrawFlag.OUTLINE ):
		draw_rect( rect, outline_color, false, outline_thickness, antialiasing );
