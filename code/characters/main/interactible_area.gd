class_name InteractibleArea extends Area2D


var _player:MainCharacter = null:
	get:
		if _player == null: _player = get_parent()
		return _player


func _ready() -> void:
	body_entered.connect(_body_entered)


func _body_entered(body) -> void:
	if body is LootItem:
		_player.add_item_to_inv(body.pickup())
