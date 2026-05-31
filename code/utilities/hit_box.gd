class_name HitBox extends Area2D


@export var damage:float = 1.0


var _parent:Characters:
	get:
		if _parent == null: _parent = get_parent() as Characters
		return _parent


func get_damage() -> float:
	if _parent != null:
		return damage
	return 0.0
