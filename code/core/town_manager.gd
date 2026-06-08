class_name TownManager extends Node2D


func _ready() -> void:
	name = &"TownManager"
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_to_group(&"town_manager")
