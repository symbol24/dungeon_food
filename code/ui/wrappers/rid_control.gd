class_name RidControl extends Control


@export var _id := &""


func toddle_display(id:StringName, display:bool) -> void:
	if id == _id:
		set_visible(display)
	else:
		set_visible(false)
