extends CanvasLayer


const INPUTLAG := 0.2
const COMMANDS := [
	"/commands",
	"commands",
	"/help",
	"help",
	"/quit",
]
const LEGENDS := [
	"Displays all available commands.", 
	"Displays all available commands.", 
	"Displays all available commands.", 
	"Displays all available commands.", 
	"Quit the game.", 
]


@export var open_debug_key := KEY_QUOTELEFT

@onready var top_box: VBoxContainer = %top_box
@onready var output: RichTextLabel = %output
@onready var input: LineEdit = %input


var _can_toggle := true


func _input(event: InputEvent) -> void:
	if event.is_action(&"debug_key"):
		if _can_toggle: 
			get_viewport().set_input_as_handled()
			_toggle_debug()

	if event.is_action(&"ui_accept"):
		if top_box.visible:
			if input.text != "":
				get_viewport().set_input_as_handled()
				_check_command(input.text)
				input.text = ""
			input.grab_focus()
		
		


func _ready() -> void:
	if not InputMap.has_action(&"debug_key"): _setup_debug_key()


func drint(...args:Array) -> void:
	var text:String = ""
	for each in args:
		text += each as String
	output.text += "\n"
	output.text += text
	print(text)


func _setup_debug_key() -> void:
	InputMap.add_action(&"debug_key")
	var event := InputEventKey.new()
	event.keycode = open_debug_key
	InputMap.action_add_event(&"debug_key", event)


func _toggle_debug() -> void:
	_can_toggle = false
	top_box.visible = !top_box.visible
	if top_box.visible:
		input.grab_focus()
		input.text = ""
	await get_tree().create_timer(INPUTLAG).timeout
	_can_toggle = true


func _check_command(command:String) -> void:
	var split:PackedStringArray = command.split(" ")
	drint(command)
	if split[0] in COMMANDS:
		match split[0]:
			COMMANDS[4]:
				get_tree().quit()
			_:
				_print_commands()
	else:
		drint("[color=yellow]Command not recognized.[/color]")


func _print_commands() -> void:
	var text := ""
	for i in COMMANDS.size():
		if i > 0: text += "\n"
		text += COMMANDS[i] + " " + LEGENDS[i]
	drint(text)
