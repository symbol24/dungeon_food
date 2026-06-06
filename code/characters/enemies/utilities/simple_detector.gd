class_name SimpleDetector extends Node2D


const DETECTLOSSTIME := 5.0


var _active := false
var _target:Characters = null
var _last_known_pos := Vector2.ZERO
var _detect_loss_timer := 0.0
var _parent:Enemy = null:
	get:
		if _parent == null: _parent = get_parent() as Enemy
		return _parent

@onready var left: RayCast2D = %left
@onready var right: RayCast2D = %right


func _ready() -> void:
	_active = true


func _physics_process(delta: float) -> void:
	if _active:
		var prev_target := _target
		var prev_pos := _last_known_pos
		if left.is_colliding():
			_detect(left)
		elif right.is_colliding():
			_detect(right)
		else:
			if _target != null: _target = null
			if _detect_loss_timer < DETECTLOSSTIME:
				_detect_loss_timer += delta
				if _detect_loss_timer >= DETECTLOSSTIME:
					_last_known_pos = Vector2.ZERO
		if _target != prev_target or _last_known_pos != prev_pos: _parent.update_target_pos(_target, _last_known_pos)


func _detect(raycast:RayCast2D) -> void:
	if _detect_loss_timer != 0.0: _detect_loss_timer = 0.0
	_target = raycast.get_collider()
	_last_known_pos = _target.global_position
