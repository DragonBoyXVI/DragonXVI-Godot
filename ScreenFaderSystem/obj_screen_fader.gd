@tool
extends Control;
class_name ObjScreenFader;
## A [Control] scene whos job is to hide/show the screen as requested.
## These objects and managed by a parent [ScreenFaderManager] node.[br]
## WARNING: 
##
## blah


## Animation name for hiding the screen.
const ANIM_HIDE := &"hide_screen";
## Animation name for showing the screen.
const ANIM_SHOW := &"show_screen";


## Emitted after this finishes playing an animation.[br]
## [br]
## screen_hidden: [bool] - Is true if the screen is hidden, and false if visible.
signal animation_finished( screen_hidden: bool );


## The hide/show animation is managed by an [AnimationPlayer] node.
@export var _animation_player: AnimationPlayer:
	set( new ):
		_animation_player = new;
		update_configuration_warnings();


func _init() -> void:
	
	mouse_filter = Control.MOUSE_FILTER_IGNORE;

func _ready() -> void:
	
	if ( Engine.is_editor_hint() ):
		
		if ( not _animation_player ):
			
			_animation_player = AnimationPlayer.new();
			add_child( _animation_player, true );
			_animation_player.owner = self;
		
		return;

func _validate_property( property: Dictionary ) -> void:
	const DISABLED := [
		"mouse_filter"
	];
	
	XVIFuncs.property_disable_by_list( DISABLED, property );

func _notification( what: int ) -> void:
	if ( what == NOTIFICATION_EDITOR_POST_SAVE ):
		update_configuration_warnings();

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray();
	
	if ( not _animation_player ):
		warnings.append( "This has no animation player!! Please either add one or close and reopen the scene." );
	else:
		
		const NO_ANIM_TEXT := "Animation player doesnt have a \"%s\" animation. Please add one!";
		if ( not _animation_player.has_animation( ANIM_HIDE ) ):
			warnings.append( NO_ANIM_TEXT % ANIM_HIDE );
		if ( not _animation_player.has_animation( ANIM_SHOW ) ):
			warnings.append( NO_ANIM_TEXT % ANIM_SHOW );
	
	return warnings;


## Call this during your hide animation to notify managers that the animation is finished.
## Can be called anywhere youd like in the animation.
func _notify_screen_hidden() -> void:
	animation_finished.emit( true );

## Call this during your show animation to notify managers that the animation is finished.
## Can be called anywhere youd like in the animation.
func _notify_screen_shown() -> void:
	animation_finished.emit( false );


## Plays the hide screen animation, and emits a signal when it finishes.
func hide_screen() -> void:
	_animation_player.play( ANIM_HIDE );
	await _animation_player.animation_finished;
	animation_finished.emit( true );

## Plays the show screen animation, and emits a signal when it finishes.
func show_screen() -> void:
	_animation_player.play( ANIM_SHOW );
