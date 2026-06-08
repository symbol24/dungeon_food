class_name SpawnManager extends Node2D


var _gm:GameManager = null:
	get:
		if _gm == null: _gm = get_tree().get_first_node_in_group(&"game_manager")
		return _gm
var  _main_character:MainCharacter = null


func _ready() -> void:
	name = &"SpawnManager"
	process_mode = Node.PROCESS_MODE_PAUSABLE
	Signals.spawn_player.connect(_spawn_main_character)
	Signals.spawn_enemies.connect(_spawn_enemies)


func _spawn_main_character(pos:Vector2) -> void:
	if _main_character == null:
		_main_character = load(_gm.player_data.uid).instantiate()

	_gm.current_chunk.add_child.call_deferred(_main_character)
	if not _main_character.is_node_ready(): await _main_character.ready

	_main_character.global_position = pos


func _spawn_enemies(dict:Dictionary) -> void:
	for k in dict.keys():
		var new:Enemy = load(dict[k].uid).instantiate()
		_gm.current_chunk.add_child.call_deferred(new)
		if not new.is_node_ready(): await new.ready
		var data:EnemyData = dict[k].duplicate()
		new.setup_character(data)
		new.global_position = k
