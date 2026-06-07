class_name Boot extends Node2D


const TARGET := "uid://dfpwpgactpk5i"


var game:GameManager


func _ready() -> void:
	Signals.all_managers_ready.connect(_continue)
	game = GameManager.new()
	get_tree().root.add_child.call_deferred(game)
	if not game.is_node_ready(): await game.ready
	game.setup_managers()


func _continue() -> void:
	get_tree().change_scene_to_file(TARGET)
	
