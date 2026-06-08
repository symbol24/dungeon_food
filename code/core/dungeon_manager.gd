class_name DungeonManager extends Node2D


func _ready() -> void:
	name = &"DungeonManager"
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_to_group(&"dungeon_manager")
