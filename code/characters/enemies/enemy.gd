class_name Enemy extends Characters


enum Animstate {IDLE, MOVE, ATTACK, HIT, DEAD}


var _current_state:Animstate = Animstate.DEAD
var _previous_state:Animstate = Animstate.MOVE
var _can_switch_state := true
var _can_move := true


func _ready() -> void:
	super()
	_update_anim_state(Animstate.IDLE)


func end_attack() -> void:
	_can_switch_state = true
	_can_move = true
	_update_anim_state(Animstate.IDLE)


func _flip() -> void:
	if not _facing_right and _direction.x > 0.0:
		_facing_right = true
	elif _facing_right and _direction.x < 0.0:
		_facing_right = false


func _update_anim_state(new_state:Animstate) -> void:
	if _can_switch_state and new_state != _previous_state:
		_previous_state = _current_state
		_current_state = new_state
		#print("entering " + Animstate.keys()[_current_state])

		match _current_state:
			Animstate.MOVE:
				animator.play(&"move")
			Animstate.ATTACK:
				animator.play(&"attack")
			Animstate.DEAD:
				animator.play(&"dead")
			Animstate.HIT:
				animator.play(&"hit")
			_:
				animator.play(&"idle")
