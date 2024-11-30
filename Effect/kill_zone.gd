
extends Area2D


var checkpoint_manager
var player

func _ready() -> void:
	checkpoint_manager = get_parent().get_parent().get_node("CheckpointManager")
	player = get_parent().get_parent().get_node("Player")
func _on_body_entered(body) -> void:
	if body.is_in_group("Player"):
		kill_player()
func kill_player():
	$Timer.start()


func _on_timer_timeout() -> void:
	player.position = checkpoint_manager.last_pos
