class_name ChunkSwitchArea extends Area2D


@export var target_chunk := &""
@export var target_spawn_point := &""


func _ready() -> void:
	set_collision_layer_value(1, false)
	set_collision_layer_value(4, true)
	set_collision_mask_value(1, false)
	add_to_group(&"switch_area")


var parent:Chunk = null:
	get:
		if parent == null: parent = get_parent()
		return parent
