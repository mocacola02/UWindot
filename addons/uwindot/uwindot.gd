@tool
extends EditorPlugin

const SCN_PATH := ^"res://addons/uwindot/scenes/uwindot_master.tscn"


func _enable_plugin() -> void:
	add_autoload_singleton("UWindotOverlay",SCN_PATH)



func _disable_plugin() -> void:
	remove_autoload_singleton("UWindotOverlay")
