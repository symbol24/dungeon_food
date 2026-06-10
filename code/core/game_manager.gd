class_name GameManager extends Node2D


const MAINCHARACTER := preload("uid://c3kgg4u3mrnia")
const TESTENEMY := preload("uid://b03gfrnhpr56j")


# Managers
var town:TownManager
var dungeon:DungeonManager
var data:SaveManager
var loot:LootSpawner
var spawn_manager:SpawnManager
var load_manager:LoadManager

# Random
var in_dungeon:bool:
	get:
		if load_manager.current_chunk.is_in_group(&"dungeon"): return load_manager.current_chunk.is_in_group(&"dungeon")
		return false
var player_data:MainCharacterData = null:
	get:
		if player_data == null: 
			player_data = MAINCHARACTER.duplicate(true)
			player_data.setup_data()
		return player_data


func _ready() -> void:
	name = &"GameManager"
	add_to_group(&"game_manager")
	process_mode = Node.PROCESS_MODE_ALWAYS


func setup_managers() -> void:
	data = SaveManager.new()
	add_child.call_deferred(data)
	if not data.is_node_ready(): await data.ready
	load_manager = LoadManager.new()
	add_child.call_deferred(load_manager)
	if not load_manager.is_node_ready(): await load_manager.ready
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
