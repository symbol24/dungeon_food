class_name LootTable extends Resource


@export var table:Array[LootTableItem]
@export var default_item_spawn_count := 1

var spawn_table:Array[LootTableItem]


func get_loot(count:int = default_item_spawn_count) -> Array[ItemData]:
	if spawn_table.is_empty(): spawn_table = table.duplicate(true)
	assert(not spawn_table.is_empty(), "Loot table is empty for " + resource_name)
	var to_return:Array[ItemData] = []
	var _max := 0

	for item in spawn_table:
		if item.current_spawn_count != 0:
			_max += item.weight
			item.current_weight = _max
		else:
			item.current_weight = -100

	for i in count:
		var check := randi_range(0, _max)
		var previous := LootTableItem.new()
		previous.current_weight = 0
		for item in spawn_table:
			if item.current_weight != -100:
				if item.current_spawn_count == 0:
					to_return.append(item.data)
					item.spawned = true
					break
				else:
					if check > previous.current_weight and check <= item.current_weight:
						to_return.append(item.data)
						item.spawned = true
						break

				previous = item

	for item in spawn_table:
		if item.spawned:
			item.current_spawn_count = item.mandatory_spawn_times
		else:
			item.current_spawn_count -= 1
		item.spawned = false

	return to_return
