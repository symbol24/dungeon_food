extends CanvasLayer


@export var uis:Dictionary[StringName, String] = {}

var previous_display := &""
var _displays:Dictionary[StringName, RidControl] = {}
var _active_display := &""


func _ready() -> void:
	name = &"UI"
	process_mode = Node.PROCESS_MODE_ALWAYS
	Signals.toggle_display.connect(_toddle_displays)


func _toddle_displays(id:StringName, display:bool) -> void:
	previous_display = _active_display
	if not _displays.has(id): _add_new_display(id)
	for k in _displays.keys():
		_displays[k].toddle_display(id, display)
	if display: _active_display = id


func _add_new_display(id:StringName) -> void:
	var display:RidControl = load(uis[id]).instantiate()
	add_child.call_deferred(display)
	_displays[id] = display
