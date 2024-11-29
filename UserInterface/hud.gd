extends Control

@onready var scene_tree = get_tree()
@onready var health_box_container = $Container/HealthBoxContainer
@onready var coin_container: HBoxContainer = $Container/CoinContainer
@onready var pause_screen: ColorRect = $PauseScreen
@onready var level_complete: TextureRect = $LevelComplete

const HEALTH_ICON = preload("res://UserInterface/Cherry.tscn")

var coin_count: int = 0


func _ready():
	coin_count = 0
	Event.level_completed.connect(_on_level_completed)
	Event.connect("health_changed", _on_health_changed)
	Event.connect("coin_collected", _on_coin_collected)

func _on_coin_collected(value) -> void:
	coin_count += value
	$Container/CoinContainer/Label.text = "%d" % coin_count

func _on_health_changed(old_health, new_health, max_health) -> void:
	var lives_left = health_box_container.get_child_count()
	
	if old_health > new_health: 
		while new_health < lives_left and lives_left > 0:
			health_box_container.remove_child(
				health_box_container.get_child(lives_left - 1)
				)
			lives_left -= 1
	else: 
		while lives_left < new_health and lives_left <= max_health:
			var cherry = HEALTH_ICON.instantiate()
			health_box_container.add_child(cherry)
			lives_left += 1

func display_level_complete():
	if not Event.curr_level < Event.level_data.size():
		$LevelComplete/TextureRect/HBoxContainer/NextLevel.visible = false
	scene_tree.call_group("buttonContainer","hide")
	pause_screen.visible = false
	$PauseButton.visible = false
	health_box_container.visible = false
	level_complete.visible = true
	
		
func _on_level_completed():
	%MoneyLabel.text = str(coin_count)
	Event.total_coin += coin_count
	var next_level = Event.curr_level + 1
	print(Event.level_data)
	if Event.level_data.has(next_level):
		Event.level_data[next_level] = false
	%FileManager.save_game()
	display_level_complete()
	
	
#LevelComplete
func home() -> void:
	print("home")
	$fader.fade_screen(true, 1.0, func(): scene_tree.change_scene_to_file("res://MainScreen/main_screen.tscn"))
func levelSelect() -> void:
	$fader.fade_screen(true, 1.0, func(): scene_tree.change_scene_to_file("res://UserInterface/Level Select/level_select.tscn"))
func nextLevel() -> void:
	var next_level :="res://Levels/level_" + str(Event.curr_level + 1) + ".tscn"
	if FileAccess.file_exists(next_level):
		Event.curr_level +=1
		$fader.fade_screen(true, 1.0, func(): scene_tree.change_scene_to_file(next_level))
	

#PauseScreen
func restart() -> void:
	coin_count = 0
	set_game_paused(false)
	scene_tree.reload_current_scene()

func set_game_paused(value: bool) -> void:
	scene_tree.paused = value
	pause_screen.visible = value
	scene_tree.call_group("buttonContainer","hide" if value else "show")
	$PauseButton.visible = not value
	
func resume() -> void:
	set_game_paused(false)
	
func pause_game():
	set_game_paused(true)

func _on_pause_button_button_down() -> void:
	set_game_paused(true)
func _on_exit_button_button_down() -> void:
	set_game_paused(false)
	home()
