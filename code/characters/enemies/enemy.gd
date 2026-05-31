class_name Enemy extends Characters


const HITCOLOR := Color(18.892, 0.0, 0.0, 0.475)

enum Animstate {IDLE, MOVE, ATTACK, DEAD}


var target:MainCharacter = null

var _current_state:Animstate = Animstate.DEAD
var _can_switch_state := true
var _can_move := true


func _ready() -> void:
	super()
	_update_anim_state(Animstate.IDLE)


func end_attack() -> void:
	_can_switch_state = true
	_can_move = true
	_update_anim_state(Animstate.IDLE)


func apply_damage(value:float) -> void:
	if not _is_invincible:
		hp -= value
		#print("HP: ", hp)
		if _current_state != Animstate.DEAD:
			if hp <= 0.0:
				hp = 0.0
				_update_anim_state(Animstate.DEAD)
			else:
				_hit()


func end_death_anim() -> void:
	# TODO: Loot spawns here
	queue_free.call_deferred()


func _hit() -> void:
	get_tree().create_timer(ITIME).timeout.connect(func (): _is_invincible = false)
	var tween := create_tween()
	for x in HITFLASHCOUNT:
		tween.tween_property(self, "modulate", HITCOLOR, ITIME/HITFLASHCOUNT/2)
		tween.tween_property(self, "modulate", Color.WHITE, ITIME/HITFLASHCOUNT/2)


func _update_anim_state(new_state:Animstate) -> void:
	if _can_switch_state:
		_current_state = new_state
		#print("entering " + Animstate.keys()[_current_state])

		match _current_state:
			Animstate.MOVE:
				animator.play(&"move")
			Animstate.ATTACK:
				animator.play(&"attack")
			Animstate.DEAD:
				animator.play(&"death")
			_:
				animator.play(&"idle")
