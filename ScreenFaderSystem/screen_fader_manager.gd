@tool
extends Control;
class_name ScreenFaderManager;


## Emitted when the set_fader_path_threaded finishes.
signal thread_finished();
## Emitted when the current fader finishes an animation.[br]
## [br]
## screen_hidden: [bool] - Is true if the screen is hidden, and false if its shown.
signal fader_animation_finished( screen_hidden: bool );


var _current_fader: ObjScreenFader;


## Uses a [PackedScene] to set the fader.
## If the provided scene isnt a fader, the game will crash with a message.
func set_fader_scene( fader_scene: PackedScene ) -> void:
	assert( fader_scene.can_instantiate() );
	
	var new_fader := fader_scene.instantiate();
	assert( new_fader is ObjScreenFader, "The scene you provide must have a root of type ObjScreenFader!!!" );
	
	if ( _current_fader ):
		_current_fader.queue_free();
	_current_fader = new_fader;
	_current_fader.animation_finished.connect( fader_animation_finished.emit );
	add_child( new_fader );

## Uses a [String] file path or UID to load and set the fader.
## There is no difference between loading the fader yourself or using this.
func set_fader_path( fader_path: String ) -> void:
	assert( ResourceLoader.exists( fader_path, "PackedScene" ), "Please provide a valid path to a fader." );
	
	var fader_scene: PackedScene = load( fader_path );
	set_fader_scene( fader_scene );

## Same as the set_fader_path function, except that the scene is loaded on a background thread.
## This is an out of the box solution, you may use your own if you wish.
func set_fader_path_threaded( fader_path: String ) -> void:
	const PACKEDSCENE := "PackedScene";
	assert( ResourceLoader.exists( fader_path, PACKEDSCENE ), "Please provide a valid path to a fader." );
	
	var fader_scene: PackedScene = await XVIFuncs.load_resource_coroutine( fader_path, PACKEDSCENE );
	set_fader_scene( fader_scene );
	thread_finished.emit();


## Makes the current fader hide the screen.
## Emits a signal when its done.
func hide_screen() -> void:
	assert( _current_fader, "Please load a fader before attempting to use them." );
	
	_current_fader.hide_screen();

## Makes the current fader show the screen.
## Emits a signal when its done.
func show_screen() -> void:
	assert( _current_fader, "Please load a fader before attempting to use them." );
	
	_current_fader.show_screen();
