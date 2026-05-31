class_name MainCharacter extends Characters


enum Animstate {IDLE, MOVE, JUMP, FALL, GROUNDATTACK1,AIRATTACK1}


var _current_state:Animstate = Animstate.IDLE
var _previous_state:Animstate = Animstate.MOVE
var _can_switch_state := true


func _ready() -> void:
	super()
	animator.animation_finished.connect(_anim_end_check)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		_jump()
	elif event.is_action_pressed("attack"):
		_attack()

func _physics_process(delta: float) -> void:
	_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = _move(delta)
	if not _can_move_x: velocity.x = 0.0
	move_and_slide()

	if not _previous_is_on_floor and is_on_floor(): _land()
	if _can_flip: _flip()
	_previous_is_on_floor = is_on_floor()


func _move(delta) -> Vector2:
	var new_vel:Vector2 = velocity
	if _direction.x == 0.0:
		new_vel.x = move_toward(new_vel.x, 0, delta * FRICTION)
		if not _current_state in [Animstate.FALL, Animstate.JUMP]: _update_anim_state(Animstate.IDLE)
	else:
		new_vel.x = move_toward(new_vel.x, _direction.x * move_speed, delta * ACCELERATION)
		if not _current_state in [Animstate.FALL, Animstate.JUMP]: _update_anim_state(Animstate.MOVE)
	
	if not is_on_floor():
		new_vel.y += _gravity * delta
		if new_vel.y > 0.0: _update_anim_state(Animstate.FALL)
	
	return new_vel


func _update_anim_state(new_state:Animstate) -> void:
	if _can_switch_state and new_state != _previous_state:
		_previous_state = _current_state
		_current_state = new_state
		#print("entering " + Animstate.keys()[_current_state])

		match _current_state:
			Animstate.MOVE:
				animator.play(&"move")
			Animstate.JUMP:
				animator.play(&"jump")
			Animstate.FALL:
				animator.play(&"fall")
			Animstate.GROUNDATTACK1:
				animator.play(&"ground_attack_1")
			Animstate.AIRATTACK1:
				animator.play(&"air_attack_1")
			_:
				animator.play(&"idle")


func _flip() -> void:
	if not _facing_right and _direction.x > 0.0:
		_facing_right = true
	elif _facing_right and _direction.x < 0.0:
		_facing_right = false

	if sprite.flip_h and _facing_right:
		sprite.flip_h = false
		sprite.position.x = 6.0
	elif not sprite.flip_h and not _facing_right:
		sprite.flip_h = true
		sprite.position.x = -8


# TODO: Implement coyote time
func _jump() -> void:
	if is_on_floor() and not _is_jumping:
		_is_jumping = true
		velocity.y = jump_velocity
		_update_anim_state(Animstate.JUMP)


func _land() -> void:
	_is_jumping = false
	_update_anim_state(Animstate.IDLE)


func _attack() -> void:
	if not _is_attacking:
		_can_flip = false
		_is_attacking = true
		if is_on_floor():
			_can_move_x = false
			_update_anim_state(Animstate.GROUNDATTACK1)
		else:
			_update_anim_state(Animstate.AIRATTACK1)
		_can_switch_state = false


func _anim_end_check(anim:StringName) -> void:
	if anim in [&"ground_attack_1", &"air_attack_1"]:
		_can_flip = true
		_is_attacking = false
		_can_switch_state = true
		_can_move_x = true
		_update_anim_state(Animstate.IDLE)
