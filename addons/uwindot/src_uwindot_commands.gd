class_name UWindotCMD extends Node

func read_command(text: String) -> void:
	get_parent().console_line.clear()
	
	if text == "":
		return
		
	print(text)
	
	var command: PackedStringArray = text.split(" ")
	
	print(command)
	
	match command[0]:
		"exit": quit_game()
		"quit": quit_game()
		_: print("Unknown command.")


##### COMMANDS #####

func quit_game() -> void:
	get_tree().quit()
