class_name LootSpawner extends Node2D


const ITEM := "uid://cvij6ohqm70on"


var packed_item:LootItem = null:
	get:
		if packed_item == null: packed_item = load(ITEM).instantiate()
		return packed_item
var items_to_spawn:Array[Array] = []


func _ready() -> void:
	name = &"LootSpawner"
	process_mode = Node.PROCESS_MODE_PAUSABLE
	Signals.spawn_loot.connect(_add_item)


func _physics_process(_delta: float) -> void:
	if not items_to_spawn.is_empty():
		var item:Array = items_to_spawn.pop_front()
		_spawn_loot(item[0], item[1])


func _add_item(loot:Array[ItemData], pos:Vector2) -> void:
	print(loot)
	assert(not loot.is_empty(), "Loot spawner received no loot.")
	assert(pos != null and pos != Vector2.ZERO, "Loot spawner received wrong position.")
	for each in loot:
		items_to_spawn.append([each.duplicate(true), pos])


func _spawn_loot(item:ItemData, pos:Vector2) -> void:
	var new:LootItem = packed_item.duplicate()
	add_child.call_deferred(new)
	if not new.is_node_ready(): await new.ready
	new.setup_item(item)
	new.global_position = pos
	new.popup()
