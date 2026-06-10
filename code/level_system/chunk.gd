class_name Chunk extends Node2D


## Connection points for the other chunks. Based on positioning and offsets.
@export var connections:Array[Marker2D]


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE


func get_spawn_point(type := &"player_spawn", target := &"") -> Marker2D:
	var points:Array[Marker2D] = _get_spawn_points(type)
	for each in points:
		if each.get_meta(&"id") == target:
			return each
	return null


func _get_spawn_points(type:StringName = "player_spawn") -> Array[Marker2D]:
	var to_return:Array[Marker2D] = []
	var children := get_children()
	for child in children:
		if child.is_in_group(type):
			to_return.append(child)
	return to_return


func get_connection_point(target:StringName) -> Marker2D:
	for each in connections:
		if each.get_meta(&"target") == target:
			return each
	return null


func _await_children() -> void:
	var children := get_children()
	for each in children:
		if not each.is_node_ready(): await each.ready
