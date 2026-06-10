class_name ChunkListData extends Resource


@export var list:Dictionary[StringName, String] = {}


func get_chunk_uid(id:StringName) -> String:
	assert(list.has(id), "Chunk data does not contain an entry for " + id)
	return list[id]
