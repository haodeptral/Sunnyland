extends Node


var last_pos 
var player

func  _ready() -> void:
	player = get_parent().get_node("Player")
	last_pos = player.global_position
	
