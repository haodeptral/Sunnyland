extends Node

class_name FileManager

const SAVE_PATH = "user://savegame.data"

func save() -> Dictionary:
	# Create a dictionary with the game state
	return {
		"total_coin": Event.total_coin,
		"level_data": Event.level_data
	}

func save_game() -> void:
	# Attempt to save the game state to the file
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if save_file:
		save_file.store_var(save())
		print(save())
		save_file.close()
	else:
		print("Error: Unable to open file for saving.")

func load_game() -> void:
	# Check if the save file exists
	if not FileAccess.file_exists(SAVE_PATH):
		print("Save file not found, creating a new one.")
		save_game()
		return
	
	# Attempt to load the game state from the file
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if save_file:
		var saved_data = save_file.get_var()
		save_file.close()

		# Update the game state from the loaded data
		Event.total_coin = saved_data.get("total_coin", 0)
		Event.level_data = saved_data.get("level_data", {})
	else:
		print("Error: Unable to open file for loading.")
