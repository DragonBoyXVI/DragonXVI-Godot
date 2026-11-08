@tool
extends SubViewport;
class_name ScreenSubViewPort;
## A [SubViewport] that sets its size override depending on the window size youve set in the project settings.
##
## While in the editor it sets its size again when you save.


func _ready() -> void:
	_size_from_settings();

func _notification( what: int ) -> void:
	if ( what == NOTIFICATION_EDITOR_POST_SAVE ):
		_size_from_settings();

func _validate_property( property: Dictionary ) -> void:
	const DISABLED := [
		"size_2d_override",
		"size_2d_override_strech",
	];
	
	XVIFuncs.property_disable_by_list( DISABLED, property );

func _size_from_settings() -> void:
	var window_size: Vector2i = Vector2i(
		ProjectSettings.get_setting( "display/window/size/viewport_width", 1280 ),
		ProjectSettings.get_setting( "display/window/size/viewport_height", 720 )
	);
	
	size_2d_override = window_size;
	size_2d_override_stretch = true;
