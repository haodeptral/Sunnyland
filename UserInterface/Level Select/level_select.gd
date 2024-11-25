extends Control

@onready var scene_tree = get_tree()
@onready var moneyLabel = $Money/Label
@onready var levelGrid = $TextureRect/LevelGrid


func _ready() -> void:
	connect_level_selected_to_level_box()
	%FileManager.load_game()
	if Event.level_data.is_empty():
		setup_level_box()
	else: 
		for box in levelGrid.get_children():
			box.level_num = box.get_index()+1
			box.locked = Event.level_data.get(box.get_index()+1)
	moneyLabel.text = str(Event.total_coin)

func setup_level_box() -> void:
	Event.level_data = {}  # Initialize as empty
	for box in levelGrid.get_children():
		box.level_num = box.get_index() + 1
		box.locked = true
		Event.level_data[box.level_num] = true  # Save the locked state
	Event.level_data[1] = false  # Unlock level 1
	levelGrid.get_child(0).locked = false
	unlock_level()
	print("Initialized level_data:", Event.level_data)
func _on_home_button_down() -> void:
	scene_tree.change_scene_to_file("res://MainScreen/main_screen.tscn")

func unlock_level():
	var i:int = 0
	while ( i < 15):
		#print(Event.level_data[i])
		levelGrid.get_child(i).locked = Event.level_data[i+1]
		i+=1
	
func connect_level_selected_to_level_box() -> void:
	for box in levelGrid.get_children():
		box.connect("level_selected",change_to_scene)

func change_to_scene(level_num: int) -> void:
	Event.curr_level = level_num
	#print("Fader?")
	$fader.fade_screen(true, 1.0, func (): scene_tree.change_scene_to_file("res://Levels/level_"+str(level_num)+ ".tscn"))
