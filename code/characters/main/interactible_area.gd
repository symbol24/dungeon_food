class_name InteractibleArea extends Area2D


var _player:MainCharacter = null:
	get:
		if _player == null: _player = get_parent()
		return _player


func _ready() -> void:
	body_entered.connect(_body_entered)
	area_entered.connect(_area_entered)


func _body_entered(body) -> void:
	if body.is_in_group(&"loot_item"):
		_player.add_item_to_inv(body.pickup())


func _area_entered(area) -> void:
	if area.is_in_group(&"switch_area"):
		Signals.load_chunk.emit(area.target_chunk, area.target_spawn_point)
