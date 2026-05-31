class_name Characters extends CharacterBody2D


const FRICTION:float = 1000.0
const ACCELERATION:float = 700.0
const ITIME := 0.4

@export var for_flipping:Array[Node2D]
@export var move_speed := 100.0
## Must be negative
@export var jump_velocity:float = -300
@export var starting_hp := 1.0

var _gravity:float = ProjectSettings.get_setting("physics/2d/default_gravity")
var _grounded := false
var _direction := Vector2.ZERO
var _is_jumping := false
var _is_attacking := false
var _facing_right := true
var _can_flip := true
var _can_move_x := true
var _can_jump := true
var _previous_is_on_floor := false
var _is_invincible := false

# Stats
var hp := 1.0
var max_hp := 1.0

@onready var sprite: Sprite2D = %sprite
@onready var animator: AnimationPlayer = %animator


func _ready() -> void:
	_setup_character()


func _physics_process(delta: float) -> void:
	velocity = _move(delta)
	if _is_jumping and is_on_ceiling_only(): _land()
	move_and_slide()


func apply_damage(value:float) -> void:
	if not _is_invincible:
		_is_invincible = true
		hp -= value
		if hp <= 0.0:
			hp = 0.0
			print("DEAD")
		else:
			get_tree().create_timer(ITIME).timeout.connect(func (): _is_invincible = false)


func _setup_character() -> void:
	max_hp = starting_hp
	hp = max_hp
	_is_jumping = false
	_is_attacking = false
	_facing_right = true
	_can_flip = true
	_can_move_x = true
	_is_invincible = false


func _move(delta) -> Vector2:
	var new_vel:Vector2 = velocity
	if _direction.x == 0.0:
		new_vel.x = move_toward(new_vel.x, 0, delta * FRICTION)
	else:
		new_vel.x = move_toward(new_vel.x, _direction.x * move_speed, delta * ACCELERATION)
	
	if not is_on_floor():
		new_vel.y += _gravity * delta
	
	return new_vel


# TODO: Implement coyote time
func _jump() -> void:
	if is_on_floor() and not _is_jumping:
		_is_jumping = true
		velocity.y = jump_velocity


func _land() -> void:
	if is_on_floor() and _is_jumping:
		_is_jumping = false


func _flip() -> void:
	pass
	#if not animated_sprite.flip_h and _facing_right:
		#animated_sprite.flip_h = true
	#elif animated_sprite.flip_h and not _facing_right:
		#animated_sprite.flip_h = false


func _attack() -> void:
	pass
