class_name LootItem extends RigidBody2D


const VERT := -100.0
const PICKUPHEIGHT := -15.0
const PICKUPTIME := 0.7
const FLASHCOUNT := 6


@export var data:ItemData

@onready var image: TileMapLayer = %image


func setup_item(new_data:ItemData) -> void:
	assert(new_data != null, "Missing Item data for loot item.")
	data = new_data.duplicate(true)
	image.set_cell(Vector2i.ZERO, 0, data.world_coords)
	name = &"loot_" + data.id


func popup() -> void:
	apply_central_impulse(Vector2(randf_range(-30, 30), VERT))


func pickup() -> ItemData:
	_pickup_animation()
	return data.duplicate(true)


func _pickup_animation() -> void:
	var tween1 := create_tween()
	tween1.finished.connect(queue_free)
	tween1.tween_property(self, "global_position", Vector2(global_position.x, global_position.y + PICKUPHEIGHT), PICKUPTIME)
	
	var tween2 := create_tween()
	var alpha := 1.0
	var color:Color = Color.WHITE
	for x in FLASHCOUNT:
		tween2.tween_property(self, "modulate", Color.TRANSPARENT, PICKUPTIME/FLASHCOUNT*2)
		tween2.tween_property(self, "modulate", color, PICKUPTIME/FLASHCOUNT*2)
		color.a = alpha - (1.0 / x)
