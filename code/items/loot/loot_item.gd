class_name LootItem extends RigidBody2D


const VERT := -100.0


@export var data:ItemData

@onready var image: TileMapLayer = %image


func setup_item(new_data:ItemData) -> void:
	assert(new_data != null, "Missing Item data for loot item.")
	data = new_data.duplicate(true)
	image.set_cell(Vector2i.ZERO, 0, data.world_coords)
	name = &"loot_" + data.id


func popup() -> void:
	apply_central_impulse(Vector2(randf_range(-30, 30), VERT))
