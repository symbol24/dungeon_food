class_name GameManager extends Node2D


const MAINCHARACTER := preload("uid://c3kgg4u3mrnia")
const TESTENEMY := preload("uid://b03gfrnhpr56j")


var town:TownManager
var dungeon:DungeonManager
var data:SaveManager
var loot:LootSpawner
var spawn_manager:SpawnManager

var in_dungeon := false
var player_data:MainCharacterData = null
var current_chunk:Chunk = null
var target_spawn_id := &"first"


func _ready() -> void:
	name = &"GameManager"
	add_to_group(&"game_manager")
	process_mode = Node.PROCESS_MODE_ALWAYS
	Signals.chunk_ready.connect(_chunk_ready)


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


func _chunk_ready(chunk:Chunk) -> void:
	assert(is_instance_valid(chunk), "Game Manager received null level chunk.")
	in_dungeon = true if chunk is LevelChunk else false
	current_chunk = chunk
	var children := chunk.get_children()
	var player_points:Array[Marker2D] = []
	var enemies:Array[Marker2D] = []
	var npc_points:Array[Marker2D] = []
	for each in children:
		if each.is_in_group(&"player_spawn"):
			player_points.append(each)
		elif each.is_in_group(&"enemy_spawn"):
			enemies.append(each)
		elif each.is_in_group(&"npc_spawn"):
			npc_points.append(each)

	assert(not player_points.is_empty(), "No player spawn points found in chunk " + chunk.name)
	
	# Debug data generation
	if player_data == null: 
		player_data = MAINCHARACTER.duplicate(true)
		player_data.setup_data()
	Signals.spawn_player.emit(_get_spawn_point(target_spawn_id, player_points).global_position)
	
	var dict := {}
	if in_dungeon:
		for each in enemies:
			dict[each.global_position] = each.get_meta(&"enemy")
		Signals.spawn_enemies.emit(dict)
	else:
		for each in npc_points:
			dict[each.global_position] = each.get_meta(&"npc")
		Signals.spawn_npcs.emit(dict)


func _get_spawn_point(id:StringName, markers:Array[Marker2D]) -> Marker2D:
	for each in markers:
		if each.get_meta(&"id") == id:
			return each
	return null
