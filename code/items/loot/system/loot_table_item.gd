class_name LootTableItem extends Resource


@export var data:ItemData
@export var weight := 0
var current_weight := 0

## If set > 0, will spawn at set spawn times (), resets when spawns. -1 will always try to spawn.
@export var mandatory_spawn_times := -1
var current_spawn_count := mandatory_spawn_times
var spawned := false
