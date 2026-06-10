class_name SpawnManager extends Node2D


var _gm:GameManager = null:
	get:
		if _gm == null: _gm = get_tree().get_first_node_in_group(&"game_manager")
		return _gm
var _dungeon_player:MainCharacter = null
var _town_player:MainCharacter = null


func _ready() -> void:
	name = &"SpawnManager"
	process_mode = Node.PROCESS_MODE_PAUSABLE
	Signals.chunk_ready.connect(_chunk_ready)
	Signals.spawn_player.connect(_spawn_main_character)


func _chunk_ready(chunk:Chunk) -> void:
	if chunk.is_in_group(&"dungeon"):
		await _spawn_enemies(chunk.get_enemies_to_spawn())
	else:
		pass

	Signals.chunk_spawning_complete.emit()


func _spawn_main_character() -> void:
	if _gm.in_dungeon:
		if _dungeon_player == null:
			_dungeon_player = load(_gm.player_data.uid).instantiate()
			_dungeon_player.setup_character(_gm.player_data)

		if _town_player != null and _town_player.get_parent():
			_town_player.get_parent().remove_child.call_deferred(_town_player)

		_gm.load_manager.current_chunk.add_child.call_deferred(_dungeon_player)
		if not _dungeon_player.is_node_ready(): await _dungeon_player.ready
		
		_dungeon_player.global_position = _gm.load_manager.current_chunk.get_spawn_point(&"player_spawn", _gm.load_manager.target_spawn).global_position
	
	else:
		if _town_player == null:
			_town_player = load(_gm.player_data.town_uid).instantiate()
			_town_player.setup_character(_gm.player_data)

		if _dungeon_player != null and _dungeon_player.get_parent():
			_dungeon_player.get_parent().remove_child.call_deferred(_dungeon_player)
		
		_gm.load_manager.current_chunk.add_child.call_deferred(_town_player)
		if not _town_player.is_node_ready(): await _town_player.ready
		
		_town_player.global_position = _gm.load_manager.current_chunk.get_spawn_point(&"player_spawn", _gm.load_manager.target_spawn).global_position


func _spawn_enemies(dict:Dictionary) -> void:
	for k in dict.keys():
		var data:EnemyData = dict[k].duplicate()
		var new:Enemy = load(data.uid).instantiate()
		_gm.current_chunk.add_child.call_deferred(new)
		if not new.is_node_ready(): await new.ready
		new.setup_character(data)
		new.global_position = k
