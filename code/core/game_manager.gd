class_name GameManager extends Node2D


var town:TownManager
var dungeon:DungeonManager
var data:SaveManager
var loot:LootSpawner
var spawn_manager:SpawnManager


func _ready() -> void:
	name = &"GameManager"
	process_mode = Node.PROCESS_MODE_ALWAYS


func setup_managers() -> void:
	data = SaveManager.new()
	add_child.call_deferred(data)
	if not data.is_node_ready(): await data.ready
	town = TownManager.new()
	add_child.call_deferred(town)
	if not town.is_node_ready(): await town.ready
	dungeon = DungeonManager.new()
	add_child.call_deferred(dungeon)
	if not dungeon.is_node_ready(): await dungeon.ready
	loot = LootSpawner.new()
	add_child.call_deferred(loot)
	if not loot.is_node_ready(): await loot.ready
	spawn_manager = SpawnManager.new()
	add_child.call_deferred(spawn_manager)
	if not spawn_manager.is_node_ready(): await spawn_manager.ready
	Signals.all_managers_ready.emit()
