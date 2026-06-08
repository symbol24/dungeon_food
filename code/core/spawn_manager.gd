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
	Signals.spawn_player.connect(_spawn_main_character)
	Signals.spawn_enemies.connect(_spawn_enemies)


func _spawn_main_character(pos:Vector2) -> void:
	if _gm.in_dungeon:
		if _dungeon_player == null:
			_dungeon_player = load(_gm.player_data.uid).instantiate()
			_dungeon_player.setup_character(_gm.player_data)

		if _town_player != null and _town_player.get_parent():
			_town_player.get_parent().remove_child.call_deferred(_town_player)

		_gm.current_chunk.add_child.call_deferred(_dungeon_player)
		if not _dungeon_player.is_node_ready(): await _dungeon_player.ready
	
	else:
		if _town_player == null:
			_town_player = load(_gm.player_data.uid).instantiate()
			_town_player.setup_character(_gm.player_data)

		if _dungeon_player != null and _dungeon_player.get_parent():
			_dungeon_player.get_parent().remove_child.call_deferred(_dungeon_player)
		
		_gm.current_chunk.add_child.call_deferred(_town_player)
		if not _town_player.is_node_ready(): await _town_player.ready

	_dungeon_player.global_position = pos


func _spawn_enemies(dict:Dictionary) -> void:
	for k in dict.keys():
		var new:Enemy = load(dict[k].uid).instantiate()
		_gm.current_chunk.add_child.call_deferred(new)
		if not new.is_node_ready(): await new.ready
		var data:EnemyData = dict[k].duplicate()
		new.setup_character(data)
		new.global_position = k
