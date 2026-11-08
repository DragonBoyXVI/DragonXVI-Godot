@tool
extends BoxContainer;
class_name FocusSortBoxContainer;
## A [BoxContainer] that sets the focus neighbor properties of its children.
##
## By default, this automatically sorts focus at runtime. But can be configued to only do so in editor
## if you prefer, among many other properties.


enum SortOption {
	## If ticked, this sorts focus during runtime.
	RUN_AT_RUNTIME = 1<<0,
	## If ticked, this sorts focus in the editor.
	RUN_IN_EDITOR = 1<<1,
	
	## If ticked, the first and last nodes have respective next focus paths point to each other.
	LOOP_FOCUS = 1<<2,
	## If ticked, [Control] nodes which are unfocusable are skipped.
	SKIP_UNFOCUSABLE = 1<<3,
	
	DEFAULT = RUN_AT_RUNTIME | SKIP_UNFOCUSABLE | LOOP_FOCUS,
}


@export_flags(
	"Run at Runtime",
	"Run in Editor",
	"Loop Focus",
	"Skip Unfocusable"
) var sort_option_flags: int = SortOption.DEFAULT;


func _init() -> void:
	
	pre_sort_children.connect( _on_pre_sort_children, CONNECT_DEFERRED );


func _sort_focus() -> void:
	
	var child_controls := _sort_child_nodes( get_children() );
	var array_size := child_controls.size();
	for i: int in array_size:
		var control: Control = child_controls[ i ];
		
		var next_control: Control = null;
		if ( i < array_size - 1 ):
			next_control = child_controls[ i + 1 ];
		elif ( sort_option_flags & SortOption.LOOP_FOCUS ):
			next_control = child_controls[ 0 ];
		
		var previous_control: Control = null;
		if ( i > 0 ):
			previous_control = child_controls[ i - 1 ];
		elif ( sort_option_flags & SortOption.LOOP_FOCUS ):
			previous_control = child_controls[ array_size - 1 ];
		
		if ( next_control ):
			
			var next_path: NodePath = control.get_path_to( next_control );
			control.focus_next = next_path;
			if ( vertical ):
				control.focus_neighbor_bottom = next_path;
			else:
				control.focus_neighbor_right = next_path;
		
		if ( previous_control ):
			
			var previous_path: NodePath = control.get_path_to( previous_control );
			control.focus_previous = previous_path;
			if ( vertical ):
				control.focus_neighbor_top = previous_path;
			else:
				control.focus_neighbor_left = previous_path;

func _sort_child_nodes( nodes: Array[ Node ] ) -> Array[ Control ]:
	var array: Array[ Control ] = [];
	
	for node: Node in nodes:
		
		if ( node is not Control ):
			continue;
		var control: Control = node;
		
		if ( sort_option_flags & SortOption.SKIP_UNFOCUSABLE ):
			if ( control.get_focus_mode_with_override() == Control.FOCUS_NONE ):
				continue;
		
		array.append( control );
	
	return array;


func _on_pre_sort_children() -> void:
	var is_in_engine := Engine.is_editor_hint();
	
	if ( is_in_engine ):
		if ( sort_option_flags & SortOption.RUN_IN_EDITOR ):
			_sort_focus();
		return;
	
	if ( sort_option_flags & SortOption.RUN_AT_RUNTIME ):
		_sort_focus();
