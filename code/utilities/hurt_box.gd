class_name HurtBox extends Area2D


var _parent:Characters:
	get:
		if _parent == null: _parent = get_parent() as Characters
		return _parent


func _ready() -> void:
	area_entered.connect(_area_entered)


func _area_entered(area:Area2D) -> void:
	if area is HitBox:
		_parent.apply_damage(area.get_damage())
