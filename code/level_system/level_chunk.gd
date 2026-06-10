class_name LevelChunk extends Chunk
# TODO: Rename level chunk to dungeon chunk


func get_enemies_to_spawn() -> Dictionary:
	var to_return := {}
	var points := _get_spawn_points(&"enemy_spawn")
	for each in points:
		to_return[each.global_position] = each.get_meta(&"enemy")
	
	return to_return
