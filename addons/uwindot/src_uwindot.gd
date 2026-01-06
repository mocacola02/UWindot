class_name UWindot extends Control

@onready var log_path: String = ProjectSettings.get("debug/file_logging/log_path")

@onready var overlay_log := $UwindotOverlay/MarginContainer/LineList
@onready var fps_label := $FPSLabel
@onready var console := $UwindotConsole
@onready var console_log := $UwindotConsole/LogScroller/LogMargin/LogContainer
@onready var console_line := $UwindotConsole/CmdLineContainer/CmdLine

@onready var overlay_theme := preload("res://addons/uwindot/resources/label_main.tres")
@onready var console_theme := preload("res://addons/uwindot/resources/label_console.tres")

@onready var CMD := $UWindotCMD

var log_access: FileAccess
var log_valid: bool
var log_entries: Array[String]

var overlay_labels: Array[Label]

var console_entries: Array[Label]
var max_entries: int = 64

#region General
func _ready() -> void:
	log_valid = get_log()
	if log_valid:
		print("UWindot: We have a valid log!")
	else:
		push_warning("Warning: UWindot continuing without log features.")

func _process(delta: float) -> void:
	if log_valid && update_log():
		update_console()
		update_overlay()
	if fps_label.visible:
		update_fps()

func _unhandled_key_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed(&'ui_filedialog_refresh'):
		if console.visible:
			console.visible = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			console.visible = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func get_log() -> bool:
	if !FileAccess.file_exists(log_path):
		push_warning("UWindot error: Could not find log file at " + log_path)
		return false
	if !log_access:
		log_access = FileAccess.open(log_path, FileAccess.READ)
		if !log_access:
			push_warning("UWindot error: Failed to read log at " + log_path)
			return false
	return true

func update_log() -> bool:
	if log_access.get_position() < log_access.get_length():
		var new_line := log_access.get_line()
		log_entries.append(new_line)
		
		if log_entries.size() >= max_entries:
			log_entries.remove_at(0)
		return true
	else:
		return false

func create_label(parent: Node, theme: LabelSettings, show_time: bool = false) -> Label:
	var new_label := Label.new()
	parent.add_child(new_label)
	
	var log_line: String = log_entries.back()
	if show_time:
		var current_time: Dictionary = Time.get_time_dict_from_system()
		var current_hours: int = current_time.get('hour')
		var current_minutes: String = str(current_time.get('minute'))
		if current_minutes.length() == 1:
			current_minutes = "0" + current_minutes
		log_line = "[" + str(current_hours) + ":" + current_minutes + "]" + log_line 
	
	new_label.text = log_line
	new_label.label_settings = theme
	return new_label
#endregion

#region Overlay Log
func update_overlay() -> void:
	overlay_labels.append(create_label(overlay_log,overlay_theme))
	
	if overlay_labels.size() >= 10:
		console_entries.remove_at(0)
#endregion

#region Console Log
func update_console() -> void:
		console_entries.append(create_label(console_log,console_theme,true))
		
		if console_entries.size() >= max_entries:
			console_entries.remove_at(0)
		
		if console.visible:
			var console_scroller := $UwindotConsole/LogScroller
			console_scroller.scroll_vertical = 9999

func _on_console_close_requested() -> void:
	console.hide()
#endregion

#region FPS
func update_fps() -> void:
	var fps := snappedf(Engine.get_frames_per_second(), 0.1)
	fps_label.text = str(fps)
#endregion

func read_command(text: String) -> void:
	console_line.clear()
	
	if text == "":
		return
		
	print(text)
	
	var command: PackedStringArray = text.split(" ")
	
	print(command)
	
	match command[0]:
		"exit": CMD.quit_game()
		"quit": CMD.quit_game()
		_: print("Unknown command.")
