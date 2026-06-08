class_name MainCharacter extends Characters


@onready var animation_tree: AnimationTree = %animation_tree


func _ready() -> void:
	super()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		_jump()
	elif event.is_action_pressed("attack"):
		_attack()


func _physics_process(delta: float) -> void:
	_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	_previous_is_on_floor = _grounded
	_grounded = _get_if_grounded()
	if not _previous_is_on_floor and _grounded: _land()

	velocity = _move(delta)
	velocity = _get_gravity(delta)
	if not _can_move_x: velocity.x = 0.0
	move_and_slide()

	if _can_flip: _flip()


func attack_end() -> void:
	_is_attacking = false
	_can_flip = true
	_can_move_x = true
	_can_jump = true
	animation_tree.set("parameters/conditions/attack", false)
	animation_tree.set("parameters/ground/conditions/ground_out", false)


func add_item_to_inv(item:ItemData) -> void:
	_data.add_item(item)


func _move(delta) -> Vector2:
	var new_vel:Vector2 = velocity
	if _direction.x == 0.0:
		new_vel.x = move_toward(new_vel.x, 0, delta * FRICTION)
		animation_tree.set("parameters/ground/conditions/move", false)
		animation_tree.set("parameters/ground/conditions/idle", true)
	else:
		new_vel.x = move_toward(new_vel.x, _direction.x * move_speed, delta * ACCELERATION)
		animation_tree.set("parameters/ground/conditions/move", true)
		animation_tree.set("parameters/ground/conditions/idle", false)

	return new_vel


func _get_gravity(delta:float) -> Vector2:
	var new_vel:Vector2 = velocity
	if not _grounded:
		new_vel.y += _gravity * delta
		if new_vel.y > 0.0 and not animation_tree.get("parameters/air/conditions/fall"):
			animation_tree.set("parameters/air/conditions/fall", true)
	return new_vel


# TODO: Implement coyote time
func _jump() -> void:
	if is_on_floor() and not _is_jumping and _can_jump:
		_is_jumping = true
		velocity.y = jump_velocity
		animation_tree.set("parameters/conditions/in_air", true)
		animation_tree.set("parameters/air/conditions/jump", true)
		animation_tree.set("parameters/air/conditions/land", false)


func _land() -> void:
	_is_jumping = false
	animation_tree.set("parameters/ground/conditions/ground_out", false)
	animation_tree.set("parameters/air/conditions/jump", false)
	animation_tree.set("parameters/air/conditions/land", true)
	animation_tree.set("parameters/air/conditions/fall", false)


func _attack() -> void:
	if not _is_attacking:
		_can_jump = false
		_can_flip = false
		_is_attacking = true
		animation_tree.set("parameters/conditions/attack", true)
		animation_tree.set("parameters/ground/conditions/ground_out", true)
		if is_on_floor():
			_can_move_x = false


func _get_if_grounded() -> bool:
	var grounded := is_on_floor()
	animation_tree.set("parameters/conditions/grounded", grounded)
	animation_tree.set("parameters/conditions/in_air", not grounded)
	animation_tree.set("parameters/attacks/conditions/grounded", grounded)
	animation_tree.set("parameters/attacks/conditions/in_air", not grounded)
	if not grounded and not animation_tree.get("parameters/ground/conditions/ground_out"): animation_tree.set("parameters/ground/conditions/ground_out", true)
	return grounded
