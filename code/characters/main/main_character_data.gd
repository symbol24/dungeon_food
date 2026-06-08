class_name MainCharacterData extends CharacterData


@export var starting_jump_velocity := -300.0
@export var inventory:Array[Array] = []

var jump_velocity := -300.0

func add_item(item:ItemData) -> void:
	assert(item != null, "Main Character Data received null item data, cannot add new item.")
	var found := false
	for each in inventory:
		if each[0].id == item.id:
			each[1] += 1
			found = true
			break
	
	if not found: inventory.append([item, 1])
