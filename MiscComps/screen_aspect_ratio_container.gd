@tool
extends AspectRatioContainer;
class_name ScreenAspectRatioContainer;
## An [AspectRatioContainer] that sets its ratio depending on the window size youve set in the project settings.
##
## While in the editor it sets its size again when you save.


func _ready() -> void:
	_size_from_settings();

func _notification( what: int ) -> void:
	if ( what == NOTIFICATION_EDITOR_POST_SAVE ):
		_size_from_settings();

func _validate_property( property: Dictionary ) -> void:
	const DISABLED := [
		"ratio",
	];
	
	XVIFuncs.property_disable_by_list( DISABLED, property );


func _size_from_settings() -> void:
	var window_size: Vector2i = Vector2i(
		ProjectSettings.get_setting( "display/window/size/viewport_width", 1280 ),
		ProjectSettings.get_setting( "display/window/size/viewport_height", 720 )
	);
	
	ratio = window_size.aspect();
