class_name ChunkSwitchArea extends Area2D


@export var target_chunk := &""
@export var target_spawn_point := &""


var parent:Chunk = null:
	get:
		if parent == null: parent = get_parent()
		return parent
