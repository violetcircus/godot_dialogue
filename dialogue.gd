extends Control

@onready var background = $Background
@onready var name_label = $Name
@onready var text_label = $Dialogue
@onready var dialogue_close = $DialogueClose
@onready var dialogue_okay = $DialogueOkay
@onready var scroll_container = $ScrollContainer
@onready var reply_container = $ScrollContainer/VBoxContainer

var reply_scene = preload("res://godot_dialogue/reply.tscn")

@export var scene_name = "Dialogue"

var line_count = 0
var dialogue
var dialogue_text
var dialogue_name
var scene_text = {}
var selected_text = []
var in_progress = false

func _ready():
	text_label.text = ""
	name_label.text = ""
	dialogue_close.visible = false
	background.visible = false
	scene_text = load_scene_text().duplicate(true)
	SignalBus.connect("display_dialog", on_display_dialog)
	
func load_scene_text():
	var file = "res://godot_dialogue/json/"+ scene_name +".json"
	var json_as_text = FileAccess.get_file_as_string(file)
	var json_as_dict = JSON.parse_string(json_as_text)
	print(json_as_dict)
	return json_as_dict

func finish():
	text_label.text = ""
	name_label.text = ""
	selected_text = []
	dialogue = {}
	dialogue_name = ""
	
	background.visible = false
	dialogue_close.visible = false
	dialogue_okay.visible = false
	scroll_container.visible = false
	in_progress = false
	get_tree().paused = false
	print("finished")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

func next_line():
	line_count += 1
	
	var contents = dialogue.keys().duplicate(true)
	print("keys 1:" + str(contents))
	
	if contents.find("replies") > 0:
		show_replies()
	else:
		dialogue = dialogue[contents[0]]
		dialogue_text = contents[0]
		print("keys 2: " + str(contents[0]))
	
	if dialogue_text == "END":
		finish()
	else:
		print(dialogue_text)
		show_text(dialogue_text)

func kill_replies():
	for child in reply_container.get_children():
		child.queue_free()

func show_replies():
	reply_toggle()
	var replies = dialogue["replies"].duplicate(true)
	var count = 0
	for reply in replies:
		var reply_button = reply_scene.instantiate()
		reply_button.text = reply
		reply_button.id = count
		reply_container.add_child(reply_button)
		count += 1
		reply_button.connect("reply_pressed", on_reply_pressed)
	return

func on_reply_pressed(id):
	kill_replies()
	reply_toggle()
	print(str(id))
	var contents = dialogue.keys().duplicate(true)
	print("contents: " + str(contents))
	dialogue = dialogue[contents[0]]
	
	contents = dialogue.keys().duplicate(true)
	
	dialogue = dialogue[contents[id]]
	dialogue_text = contents[id]
	
	print("dialogue: " + str(dialogue))
	
	scroll_container.visible = false
	if dialogue_text == "END":
		print("reply end")
		finish()
	else: 
		print("not end")
		show_text(dialogue_text)

func show_text(text):
	name_label.text = dialogue_name
	text_label.text = text

func reply_toggle():
	dialogue_okay.visible = !dialogue_okay.visible
	dialogue_close.visible = !dialogue_close.visible
	name_label.visible = !name_label.visible
	text_label.visible = !text_label.visible
	scroll_container.visible = !scroll_container.visible
	
func on_display_dialog(text_key):
	if in_progress:
		print("in progress")
		next_line()
	else:
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		background.visible = true
		dialogue_close.visible = true
		dialogue_okay.visible = true
		in_progress = true
		selected_text = scene_text[text_key.to_snake_case()].duplicate(true)
		dialogue = selected_text["dialogue"]
		dialogue_name = text_key
		next_line()
