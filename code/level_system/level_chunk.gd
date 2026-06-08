class_name LevelChunk extends Node2D


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	add_to_group(&"level_chunk")
	await _await_children()
	Signals.level_chunk_ready.emit(self)


func _await_children() -> void:
	var children := get_children()
	for each in children:
		if not each.is_node_ready(): await each.ready
