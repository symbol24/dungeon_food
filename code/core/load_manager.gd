class_name LoadManager extends Node2D


const CHUNKS := preload("uid://do8ncfwhnema4")


var target_spawn_id := &"first"
var current_chunk:Chunk = null
var _previous_chunk:Chunk = null
var _current_chunk_id := &"first"
var _loaded_chunks:Dictionary[StringName, Chunk] = {}
var _progress := []
var _loading := false
var _target_chunk_uid := ""
var _target_chunk := &""
var target_spawn := &""


func _ready() -> void:
	name = &"LoadManager"
	add_to_group(&"load_manager")
	process_mode = Node.PROCESS_MODE_ALWAYS
	Signals.load_chunk.connect(_load_chunk)
	Signals.chunk_spawning_complete.connect(_chunk_spawning_complete)


func _process(_delta: float) -> void:
	if _loading:
		ResourceLoader.load_threaded_get_status(_target_chunk_uid, _progress)
		if _progress[0] >= 1.0: _load_complete()


func _load_chunk(_target:StringName, _spawn_point:StringName) -> void:
	if _loading: 
		push_warning("Load request received while already loading.")
		return

	_target_chunk = _target
	target_spawn = _spawn_point
	if _loaded_chunks.has(_target_chunk):
		_reparent_chunk()
		return
	
	_target_chunk_uid = CHUNKS.get_chunk_uid(_target_chunk)
	ResourceLoader.load_threaded_request(_target_chunk_uid)
	_loading = true


func _load_complete() -> void:
	_loading = false
	_previous_chunk = current_chunk
	var new_chunk = ResourceLoader.load_threaded_get(_target_chunk_uid).instantiate()
	get_tree().root.add_child.call_deferred(new_chunk)
	if not new_chunk.is_node_ready: await new_chunk.ready
	_loaded_chunks[_target_chunk] = new_chunk
	if _previous_chunk:
		var connection:Marker2D = _previous_chunk.get_connection_point(_target_chunk)
		new_chunk.global_position = connection.global_position
	Signals.chunk_ready.emit(new_chunk)


func _reparent_chunk() -> void:
	_previous_chunk = current_chunk
	get_tree().root.add_child.call_deferred(_loaded_chunks[_target_chunk])
	Signals.chunk_ready.emit(_loaded_chunks[_target_chunk])


func _chunk_spawning_complete() -> void:
	_move_to_target_chunk(_target_chunk)


func _move_to_target_chunk(chunk_id:StringName) -> void:
	current_chunk = _loaded_chunks[_target_chunk]
	_current_chunk_id = chunk_id
	Signals.spawn_player.emit()
	
	# After moving character to new chunk, we need to remove_child old chunk
	# we also need to unspawn all enemies and interactibles
