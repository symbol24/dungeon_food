class_name Boot extends Node2D


const TARGET := &"test_town_chunk_01"
const SPAWN := &"first_spawn"


var game:GameManager


func _ready() -> void:
	Signals.all_managers_ready.connect(_continue)
	game = GameManager.new()
	get_tree().root.add_child.call_deferred(game)
	if not game.is_node_ready(): await game.ready
	game.setup_managers()


func _continue() -> void:
	Signals.load_chunk.emit(TARGET, SPAWN)
	
